class DeleteDataFromReviewRequest < ActiveRecord::Migration[6.0]
  def change
    remove_column :review_requests, :data
  end
end
