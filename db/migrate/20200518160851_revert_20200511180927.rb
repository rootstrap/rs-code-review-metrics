class Revert20200511180927 < ActiveRecord::Migration[6.0]
  def up
    change_column_default(:review_requests, :state, nil)
    execute <<-SQL
      ALTER TYPE review_request_state RENAME TO review_request_state_old;
      CREATE TYPE review_request_state AS ENUM ('active', 'removed');
      ALTER TABLE review_requests ALTER COLUMN state TYPE review_request_state USING state::text::review_request_state;
      DROP TYPE review_request_state_old;
    SQL
    change_column_default(:review_requests, :state, 'active')
  end

  def down
    execute <<-SQL
      ALTER TYPE review_request_state ADD VALUE 'reviewed';
    SQL
  end
end
