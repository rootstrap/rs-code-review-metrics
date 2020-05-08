# == Schema Information
#
# Table name: review_requests
#
#  id              :bigint           not null, primary key
#  state           :enum             default("active")
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  owner_id        :bigint
#  pull_request_id :bigint           not null
#  reviewer_id     :bigint           not null
#
# Indexes
#
#  index_review_requests_on_owner_id         (owner_id)
#  index_review_requests_on_pull_request_id  (pull_request_id)
#  index_review_requests_on_reviewer_id      (reviewer_id)
#  index_review_requests_on_state            (state)
#
# Foreign Keys
#
#  fk_rails_...  (owner_id => users.id)
#  fk_rails_...  (pull_request_id => pull_requests.id)
#  fk_rails_...  (reviewer_id => users.id)
#
class ReviewRequest < ApplicationRecord
  enum state: { active: 'active', removed: 'removed' }

  belongs_to :owner, class_name: 'User',
                     foreign_key: :owner_id,
                     inverse_of: :owned_review_requests
  belongs_to :reviewer,
             class_name: 'User',
             foreign_key: :reviewer_id,
             inverse_of: :received_review_requests
  belongs_to :pull_request, class_name: 'Events::PullRequest',
                            inverse_of: :review_requests
  has_many :reviews, class_name: 'Events::Review',
                     dependent: :destroy

  validates :state, inclusion: { in: states.keys }
  validates :pull_request_id, uniqueness: { scope: %i[owner_id reviewer_id] }
end
