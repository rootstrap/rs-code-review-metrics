class CreateReviewRequestUsersJoinTable < ActiveRecord::Migration[6.0]
  def change
    create_join_table :review_requests, :users do |t|
      t.index %i[review_request_id user_id]
    end
  end
end
