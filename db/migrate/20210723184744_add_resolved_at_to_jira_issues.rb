class AddResolvedAtToJiraIssues < ActiveRecord::Migration[6.0]
  def change
    add_column :jira_issues, :resolved_at, :datetime
  end
end
