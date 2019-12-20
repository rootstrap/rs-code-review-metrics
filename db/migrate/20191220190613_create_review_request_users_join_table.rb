class CreateReviewRequestUsersJoinTable < ActiveRecord::Migration[6.0]
  def change
    create_join_table :review_requests, :users do |t|
      t.index [:review_request_id, :user_id]
      # t.index [:user_id, :review_request_id]
    end
  end
end
