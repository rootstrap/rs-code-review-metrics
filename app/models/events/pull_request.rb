# == Schema Information
#
# Table name: pull_requests
#
#  id         :bigint           not null, primary key
#  body       :text
#  closed_at  :datetime
#  draft      :boolean          not null
#  locked     :boolean          not null
#  merged_at  :datetime
#  number     :integer          not null
#  opened_at  :datetime
#  state      :enum
#  title      :text             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  github_id  :bigint           not null
#  node_id    :string           not null
#
# Indexes
#
#  index_pull_requests_on_github_id  (github_id) UNIQUE
#
module Events
  class PullRequest < ApplicationRecord
    ACTIONS = %w[open review_requested closed \
                 review_request_removed].freeze
    private_constant :ACTIONS

    enum state: { open: 'open', closed: 'closed' }

    has_many :review_requests, dependent: :destroy, inverse_of: :pull_request
    has_many :events, as: :handleable, dependent: :destroy

    validates :state, inclusion: { in: states.keys }
    validates :github_id,
              :state,
              :node_id,
              :title,
              :number,
              presence: true
    validates :draft,
              :locked,
              inclusion: { in: [true, false] }
    validates :github_id, uniqueness: true

    attr_accessor :payload

    def resolve
      return unless handleable?

      handle_action
    end

    private

    def handle_action
      send(payload['action'])
    end

    def find_or_create_user(user_data)
      User.find_or_create_by!(github_id: user_data['id']) do |user|
        user.node_id = user_data['node_id']
        user.login = user_data['login']
      end
    end

    def find_or_create_pull_request(payload)
      pr_data = payload['pull_request']
      pr = Events::PullRequest.find_or_create_by!(github_id: pr_data['id']) do |preq|
        preq.node_id = pr_data['node_id']
        preq.number = pr_data['number']
        preq.state = pr_data['state']
        preq.locked = pr_data['locked']
        preq.draft = pr_data['draft']
        preq.title = pr_data['title']
        preq.body = pr_data['body']
      end
      pr.assign_attributes(payload: payload)
      pr
    end

    def handleable?
      ACTIONS.include?(payload['action'])
    end

    # Actions

    def open
      open!
      self.opened_at = Time.current
      save!
    end

    def merged
      self.merged_at = Time.current
      save!
    end

    def closed
      merged if payload['pull_request']['merged'] == true
      closed!
      self.closed_at = Time.current
      save!
    end

    def review_request_removed
      reviewer = find_or_create_user(payload['requested_reviewer'])
      review_requests.find_by!(reviewer: reviewer).removed!
    end

    def review_requested
      owner = find_or_create_user(payload['pull_request']['user'])
      reviewer = find_or_create_user(payload['requested_reviewer'])
      review_requests.create!(owner: owner, reviewer: reviewer)
    end
  end
end
