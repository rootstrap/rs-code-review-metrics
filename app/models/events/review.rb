# == Schema Information
#
# Table name: events_reviews
#
#  id                :bigint           not null, primary key
#  body              :string
#  opened_at         :datetime         not null
#  state             :enum             not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  github_id         :bigint
#  owner_id          :bigint
#  pull_request_id   :bigint           not null
#  repository_id     :bigint
#  review_request_id :bigint
#
# Indexes
#
#  index_events_reviews_on_owner_id           (owner_id)
#  index_events_reviews_on_pull_request_id    (pull_request_id)
#  index_events_reviews_on_repository_id      (repository_id)
#  index_events_reviews_on_review_request_id  (review_request_id)
#  index_events_reviews_on_state              (state)
#
# Foreign Keys
#
#  fk_rails_...  (owner_id => users.id)
#  fk_rails_...  (pull_request_id => events_pull_requests.id)
#  fk_rails_...  (repository_id => repositories.id)
#

module Events
  class Review < ApplicationRecord
    enum state: { approved: 'approved',
                  commented: 'commented',
                  changes_requested: 'changes_requested',
                  dismissed: 'dismissed' }

    has_many :events, as: :handleable, dependent: :destroy
    belongs_to :repository, class_name: '::Repository', inverse_of: :reviews
    belongs_to :owner, class_name: 'User',
                       foreign_key: :owner_id,
                       inverse_of: :owned_reviews
    belongs_to :pull_request, class_name: 'Events::PullRequest',
                              inverse_of: :reviews
    belongs_to :review_request

    validates :state, inclusion: { in: states.keys }
    validates :github_id, :opened_at, presence: true

    after_create :build_review_or_comment_turnaround

    private

    def build_review_or_comment_turnaround
      Builders::ReviewOrCommentTurnaround.call(review_request, pull_request, self)
    end
  end
end
