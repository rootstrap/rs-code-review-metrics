class ChangeReviewRequestsStatus < ActiveRecord::Migration[6.0]
  def up
    execute <<-SQL
      CREATE TYPE review_request_state AS ENUM ('active', 'removed');
    SQL
    add_column :review_requests, :state, :review_request_state, default: 'active'
    add_index :review_requests, :state
  end

  def down
    remove_index :review_requests, :state
    remove_column :review_requests, :state
    execute <<-SQL
      DROP TYPE review_request_state;
    SQL
  end
end
