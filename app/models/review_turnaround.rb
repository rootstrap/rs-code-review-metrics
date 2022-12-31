# == Schema Information
#
# Table name: review_turnarounds
#
#  id                :bigint           not null, primary key
#  value             :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  pull_request_id   :bigint
#  review_request_id :bigint           not null
#
# Indexes
#
#  index_review_turnarounds_on_pull_request_id    (pull_request_id)
#  index_review_turnarounds_on_review_request_id  (review_request_id)
#
# Foreign Keys
#
#  fk_rails_...  (pull_request_id => events_pull_requests.id)
#  fk_rails_...  (review_request_id => review_requests.id)
#

class ReviewTurnaround < ApplicationRecord
  include EntityTimeRepresentation

  belongs_to :review_request
  belongs_to :pull_request, class_name: 'Events::PullRequest'

  validates :value, presence: true
  validates :review_request_id, uniqueness: true, strict: Reviews::ReviewRequestUniquenessError
end
