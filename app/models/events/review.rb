# == Schema Information
#
# Table name: reviews
#
#  id                :bigint           not null, primary key
#  body              :string
#  deleted_at        :datetime
#  opened_at         :datetime         not null
#  state             :enum             not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  github_id         :integer
#  owner_id          :bigint
#  project_id        :bigint
#  pull_request_id   :bigint           not null
#  review_request_id :bigint
#
# Indexes
#
#  index_reviews_on_owner_id           (owner_id)
#  index_reviews_on_project_id         (project_id)
#  index_reviews_on_pull_request_id    (pull_request_id)
#  index_reviews_on_review_request_id  (review_request_id)
#  index_reviews_on_state              (state)
#
# Foreign Keys
#
#  fk_rails_...  (owner_id => users.id)
#  fk_rails_...  (pull_request_id => pull_requests.id)
#

module Events
  class Review < ApplicationRecord
    acts_as_paranoid

    enum state: { approved: 'approved',
                  commented: 'commented',
                  changes_requested: 'changes_requested',
                  dismissed: 'dismissed' }

    has_many :events, as: :handleable, dependent: :destroy
    belongs_to :project, inverse_of: :reviews
    belongs_to :owner, class_name: 'User',
                       foreign_key: :owner_id,
                       inverse_of: :owned_reviews
    belongs_to :pull_request, class_name: 'Events::PullRequest',
                              inverse_of: :reviews
    belongs_to :review_request

    validates :state, inclusion: { in: states.keys }
    validates :github_id, :opened_at, presence: true

    after_create :build_review_turnaround, :build_completed_review_turnaround

    private

    def build_review_turnaround
      return unless uniq_review_on_review_request?

      Builders::ReviewTurnaround.call(review_request)
    end

    def build_completed_review_turnaround
      return unless second_review_with_different_users? && uniq_review_on_review_request?

      Builders::CompletedReviewTurnaround.call(self)
    end

    def second_review_with_different_users?
      pull_request.reviews.select(:owner_id).distinct.count == 2
    end

    def uniq_review_on_review_request?
      review_request.reviews.count.equal?(1)
    end
  end
end
