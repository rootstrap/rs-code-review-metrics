class RemoveJiraProjectFromProject < ActiveRecord::Migration[6.0]
  def up
    change_table :jira_projects do |t|
      t.remove :project_id
    end
  end

  def down
    change_table :jira_projects do |t|
      t.references :project, foreign_key: true
    end
  end
end
