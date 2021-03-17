class AddIssueKeyToJiraIssues < ActiveRecord::Migration[6.0]
  def change
    add_column :jira_issues, :key, :string
  end
end
