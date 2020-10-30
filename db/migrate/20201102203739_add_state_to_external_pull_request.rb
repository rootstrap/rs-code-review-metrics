class AddStateToExternalPullRequest < ActiveRecord::Migration[6.0]
  def up
    execute <<-SQL
      CREATE TYPE external_pull_request_state AS ENUM ('open', 'closed', 'merged');
    SQL

    add_column :external_pull_requests, :state, :external_pull_request_state
  end

  def down
    remove_column :external_pull_requests, :state
    execute <<-SQL
      DROP TYPE external_pull_request_state;
    SQL
  end
end
