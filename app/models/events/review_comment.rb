# == Schema Information
#
# Table name: review_comments
#
#  id              :bigint           not null, primary key
#  body            :string
#  status          :enum             default("active")
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  github_id       :integer
#  owner_id        :bigint
#  pull_request_id :bigint           not null
#
# Indexes
#
#  index_review_comments_on_owner_id         (owner_id)
#  index_review_comments_on_pull_request_id  (pull_request_id)
#
# Foreign Keys
#
#  fk_rails_...  (owner_id => users.id)
#  fk_rails_...  (pull_request_id => pull_requests.id)
#

module Events
  class ReviewComment < ApplicationRecord
    ACTIONS = %w[created edited deleted].freeze

    enum status: { active: 'active', removed: 'removed' }

    has_many :events, as: :handleable, dependent: :destroy
    belongs_to :owner, class_name: 'User',
                       foreign_key: :owner_id,
                       inverse_of: :owned_review_requests
    belongs_to :pull_request, class_name: 'Events::PullRequest',
                              inverse_of: :review_requests

    validates :status, inclusion: { in: statuses.keys }

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

    def find_or_create_review_comment(payload)
      rc_data = payload['comment']
      rc = Events::ReviewComment.find_or_create_by!(github_id: rc_data['id']) do |rcom|
        rcom.owner = find_or_create_user(rc_data['user'])
        rcom.pull_request = Events::PullRequest.find_by!(github_id: payload['pull_request']['id'])
      end
      rc.assign_attributes(payload: payload)
      rc
    end

    def handleable?
      ACTIONS.include?(payload['action'])
    end

    # Actions

    def created
      update!(body: payload['comment']['body'])
    end

    def edited
      update!(body: payload['changes']['body'])
    end

    def deleted
      removed!
    end
  end
end
