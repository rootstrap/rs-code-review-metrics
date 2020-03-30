class ReviewRequestsReviewsRelation < ActiveRecord::Migration[6.0]
  def change
    add_reference :reviews, :review_request
  end
end
