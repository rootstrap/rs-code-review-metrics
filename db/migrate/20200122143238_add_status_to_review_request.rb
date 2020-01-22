class AddStatusToReviewRequest < ActiveRecord::Migration[6.0]
  def change
    add_column :review_requests, :status, :string
  end
end
