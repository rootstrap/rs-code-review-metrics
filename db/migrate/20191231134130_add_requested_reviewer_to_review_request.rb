class AddRequestedReviewerToReviewRequest < ActiveRecord::Migration[6.0]
  def change
    add_reference :review_requests, :reviewer, null: false, foreign_key: { to_table: :users }
  end
end
