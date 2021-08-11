class ChangeJiraProjectsToJiraBoards < ActiveRecord::Migration[6.0]
  def up
    rename_table :jira_projects, :jira_boards
  end

  def down
    rename_table :jira_boards, :jira_projects

    change_table :jira_issues do |t|
      t.references :jira_project, foreign_key: true
    end

    JiraIssue.with_deleted.find_each do |issue|
      issue.update(jira_project_id: issue.jira_board_id)
    end

    remove_column :jira_issues, :jira_board_id
  end
end
