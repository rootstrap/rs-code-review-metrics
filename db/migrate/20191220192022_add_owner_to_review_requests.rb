class AddOwnerToReviewRequests < ActiveRecord::Migration[6.0]
  def change
    add_reference(:review_requests, :owner, foreign_key: {to_table: :users})
  end
end
