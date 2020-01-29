# == Schema Information
#
# Table name: events
#
#  id              :bigint           not null, primary key
#  data            :jsonb
#  handleable_type :string
#  name            :string
#  type            :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  handleable_id   :bigint
#
# Indexes
#
#  index_events_on_handleable_type_and_handleable_id  (handleable_type,handleable_id)
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

    attr_accessor :pull_request, :action, :requested_reviewer

    def resolve
      public_send(action) if handleable?
    end

    # Actions

    def opened
      GithubJobs::OpenedJob.perform_later(pull_request)
    end

    def closed
      GithubJobs::ClosedJob.perform_later(pull_request)
    end

    def review_requested
      GithubJobs::ReviewRequestJob.perform_later(pull_request)
    end

    def review_request_removed
      GithubJobs::ReviewRemovalJob.perform_later(pull_request)
    end

    private

    ACTIONS = %w[opened review_requested closed \
                 merged review_request_removed].freeze

    def handleable?
      ACTIONS.include?(action)
    end
  end
end
