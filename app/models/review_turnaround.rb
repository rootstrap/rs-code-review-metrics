# == Schema Information
#
# Table name: review_turnarounds
#
#  id                :bigint           not null, primary key
#  value             :integer
#  review_request_id :bigint           not null
#
# Indexes
#
#  index_review_turnarounds_on_review_request_id  (review_request_id)
#
# Foreign Keys
#
#  fk_rails_...  (review_request_id => review_requests.id)
#

class ReviewTurnaround < ApplicationRecord
  belongs_to :review_request

  def build
    set_attributes
  end

  private

  def set_attributes
    self.value = calculate_turnaround
    self
  end

  def calculate_turnaround
    review_request.reviews.first.opened_at.to_i - review_request.created_at.to_i
  end
end
