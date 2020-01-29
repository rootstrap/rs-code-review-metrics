# == Schema Information
#
# Table name: pull_requests
#
#  id         :bigint           not null, primary key
#  body       :text
#  closed_at  :datetime
#  draft      :boolean          not null
#  locked     :boolean          not null
#  merged     :boolean          not null
#  merged_at  :datetime
#  number     :integer          not null
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
    has_many :review_requests, dependent: :destroy, inverse_of: :pull_request
    has_many :events, as: :handleable

    enum state: { open: 'open', closed: 'closed' }

    validates :state, inclusion: { in: states.keys }
    validates :github_id,
              :state,
              :node_id,
              :title,
              :number,
              presence: true
    validates :draft,
              :merged,
              :locked,
              inclusion: { in: [true, false] }
    validates :github_id, uniqueness: true

    ACTIONS = %w[opened review_requested closed \
                 merged review_request_removed].freeze
    private_constant :ACTIONS

    attr_accessor :pull_request, :action, :requested_reviewer

    def resolve
      public_send(action) if handleable?
    end

    # Actions

    def merged
      PullRequestJobs::MergedJob.perform_later(pull_request)
    end

    def opened
      PullRequestJobs::OpenedJob.perform_later(pull_request)
    end

    def closed
      PullRequestJobs::ClosedJob.perform_later(pull_request)
    end

    def review_requested
      PullRequestJobs::ReviewRequestedJob.perform_later(pull_request)
    end

    def review_request_removed
      PullRequestJobs::ReviewRequestRemovedJob.perform_later(pull_request)
    end

    private

    def handleable?
      ACTIONS.include?(action)
    end
  end
end
