class AddBoardIdToJiraProject < ActiveRecord::Migration[6.0]
  def change
    change_table :jira_projects, bulk: true do |t|
      t.integer :jira_board_id
      t.string :jira_self_url
    end
  end
end
