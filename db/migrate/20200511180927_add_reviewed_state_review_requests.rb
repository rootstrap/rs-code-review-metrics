class AddReviewedStateReviewRequests < ActiveRecord::Migration[6.0]
  def up
    execute <<-SQL
      ALTER TYPE review_request_state ADD VALUE 'reviewed';
    SQL
  end

  def down
    execute <<-SQL
      ALTER TYPE review_request_state RENAME TO review_request_state_old;
      CREATE TYPE review_request_state AS ENUM ('active', 'removed');
      ALTER TABLE review_requests ALTER COLUMN name TYPE review_request_state USING name::text::review_request_state;
      DROP TYPE review_request_state_old;
    SQL
  end
end
