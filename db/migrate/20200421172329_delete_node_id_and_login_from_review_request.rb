class DeleteNodeIdAndLoginFromReviewRequest < ActiveRecord::Migration[6.0]
  def change
    remove_column :review_requests, :node_id
    remove_column :review_requests, :login
  end
end
