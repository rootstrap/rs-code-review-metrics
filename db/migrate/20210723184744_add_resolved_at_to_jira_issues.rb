class AddResolvedAtToJiraIssues < ActiveRecord::Migration[6.0]
  def change
    change_table :users, bulk: true do |t|
      add_column :jira_issues, :resolved_at, :datetime
      add_column :jira_issues, :in_progress_at, :datetime
    end
  end
end
