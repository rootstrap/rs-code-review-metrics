# == Schema Information
#
# Table name: events_pull_request_comments
#
#  id                :bigint           not null, primary key
#  body              :string
#  deleted_at        :datetime
#  opened_at         :datetime         not null
#  state             :enum             default("created")
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  github_id         :integer
#  owner_id          :bigint
#  pull_request_id   :bigint           not null
#  review_request_id :bigint
#
# Indexes
#
#  index_events_pull_request_comments_on_deleted_at         (deleted_at)
#  index_events_pull_request_comments_on_owner_id           (owner_id)
#  index_events_pull_request_comments_on_pull_request_id    (pull_request_id)
#  index_events_pull_request_comments_on_review_request_id  (review_request_id)
#  index_events_pull_request_comments_on_state              (state)
#
# Foreign Keys
#
#  fk_rails_...  (owner_id => users.id)
#  fk_rails_...  (pull_request_id => pull_requests.id)
#

module Events
  class PullRequestComment < ApplicationRecord
    acts_as_paranoid

    enum state: { created: 'created', edited: 'edited', deleted: 'deleted' }

    has_many :events, as: :handleable, dependent: :destroy
    belongs_to :owner, class_name: 'User',
                       foreign_key: :owner_id,
                       inverse_of: :owned_pull_request_comments
    belongs_to :pull_request, class_name: 'Events::PullRequest'
    belongs_to :review_request

    validates :state, inclusion: { in: states.keys }
    validates :github_id, :body, :opened_at, presence: true

    after_create :build_review_or_comment_turnaround

    private

    def build_review_or_comment_turnaround
      Builders::ReviewOrCommentTurnaround.call(review_request, pull_request, self)
    end
  end
end
