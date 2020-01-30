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
    ACTIONS = %w[opened review_requested closed \
                 merged review_request_removed].freeze
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
              :merged,
              :locked,
              inclusion: { in: [true, false] }
    validates :github_id, uniqueness: true

    class << self
      def resolve(payload)
        action = payload[:action]
        public_send(action, payload) if handleable?(action)
      end

      # Actions

      def merged(payload)
        PullRequestJobs::MergedJob.perform_later(payload)
      end

      def opened(payload)
        PullRequestJobs::OpenedJob.perform_later(payload)
      end

      def closed(payload)
        PullRequestJobs::ClosedJob.perform_later(payload)
      end

      def review_requested(payload)
        PullRequestJobs::ReviewRequestedJob.perform_later(payload)
      end

      def review_request_removed(payload)
        PullRequestJobs::ReviewRequestRemovedJob.perform_later(payload)
      end

      private

      def handleable?(action)
        ACTIONS.include?(action)
      end
    end
  end
end
