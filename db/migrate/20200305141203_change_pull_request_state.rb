class ChangePullRequestState < ActiveRecord::Migration[6.0]
  def up
    execute <<-SQL
      ALTER TYPE state RENAME TO pull_request_state;
    SQL
    add_index :pull_requests, :state
  end

  def down
    remove_index :pull_requests, :state
    execute <<-SQL
      ALTER TYPE pull_request_state RENAME TO state;
    SQL
  end
end
