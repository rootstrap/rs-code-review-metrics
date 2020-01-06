class DeleteReviewRequestsUsersTable < ActiveRecord::Migration[6.0]
  def up
    drop_table :review_requests_users
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
