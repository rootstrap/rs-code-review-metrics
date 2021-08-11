class AddReferenceJiraIssuesToJiraBoards < ActiveRecord::Migration[6.0]
  def up
    change_table :jira_issues do |t|
      t.references :jira_board, foreign_key: true
    end

    execute <<-SQL
      UPDATE jira_issues
      SET jira_board_id = jira_project_id
    SQL

    remove_column :jira_issues, :jira_project_id
  end
end
