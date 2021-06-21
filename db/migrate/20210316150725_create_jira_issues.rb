class CreateJiraIssues < ActiveRecord::Migration[6.0]
  def up
    execute <<-SQL
      CREATE TYPE issue_type AS ENUM ('bug', 'task', 'epic', 'story');
      CREATE TYPE environment AS ENUM ('not_assigned', 'local', 'development', 'qa', 'staging', 'production');
    SQL

    create_table :jira_issues do |t|
      t.references :jira_project, null: false, foreign_key: true
      t.datetime :informed_at, null: false
      t.timestamps null: false
    end

    add_column :jira_issues, :issue_type, :issue_type, null: false
    add_column :jira_issues, :environment, :environment
  end

  def down
    drop_table :jira_issues

    execute <<-SQL
      DROP TYPE issue_type;
      DROP TYPE environment;
    SQL
  end
end
