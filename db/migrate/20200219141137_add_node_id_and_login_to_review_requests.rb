class AddNodeIdAndLoginToReviewRequests < ActiveRecord::Migration[6.0]
  def change
    add_column :review_requests, :node_id, :string, null: false
    add_column :review_requests, :login, :string, null: false
  end
end
