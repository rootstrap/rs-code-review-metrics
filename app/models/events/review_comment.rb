# == Schema Information
#
# Table name: events_review_comments
#
#  id              :bigint           not null, primary key
#  body            :string
#  deleted_at      :datetime
#  state           :enum             default("active")
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  github_id       :integer
#  owner_id        :bigint
#  pull_request_id :bigint           not null
#
# Indexes
#
#  index_events_review_comments_on_owner_id         (owner_id)
#  index_events_review_comments_on_pull_request_id  (pull_request_id)
#  index_events_review_comments_on_state            (state)
#
# Foreign Keys
#
#  fk_rails_...  (owner_id => users.id)
#  fk_rails_...  (pull_request_id => events_pull_requests.id)
#

module Events
  class ReviewComment < ApplicationRecord
    acts_as_paranoid

    enum state: { active: 'active', removed: 'removed' }

    has_many :events, as: :handleable, dependent: :destroy
    belongs_to :owner, class_name: 'User',
                       foreign_key: :owner_id,
                       inverse_of: :owned_review_comments
    belongs_to :pull_request, class_name: 'Events::PullRequest',
                              inverse_of: :review_requests

    validates :state, inclusion: { in: states.keys }
    validates :github_id, :body, presence: true
  end
end
