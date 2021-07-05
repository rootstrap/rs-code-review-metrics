class CreateJiraProjects < ActiveRecord::Migration[6.0]
  def change
    create_table :jira_projects do |t|
      t.references :project, foreign_key: true
      t.string :jira_project_key, null: false
      t.string :project_name
      t.timestamps null: false
    end
  end
end
