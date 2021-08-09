class ChangePullRequestCommentsState < ActiveRecord::Migration[6.0]
  def up
    execute <<-SQL
      CREATE TYPE pull_request_comment_state AS ENUM ('created', 'edited', 'deleted');
    SQL
    add_column :pull_request_comments, :state, :pull_request_comment_state, default: 'created'
    add_index :pull_request_comments, :state
  end

  def down
    remove_index :pull_request_comments, :state
    remove_column :pull_request_comments, :state
    execute <<-SQL
      DROP TYPE pull_request_comment_state;
    SQL
  end
end
