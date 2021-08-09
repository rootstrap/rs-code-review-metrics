class DropJiraProjectsTable < ActiveRecord::Migration[6.0]
  def up
    execute <<-SQL
      UPDATE jira_issues AS T1
      SET product_id = T2.id
      FROM
        products AS T2
        INNER JOIN jira_projects AS T3
        ON T2.id = T3.product_id
      WHERE
        T1.jira_project_id = T3.id;
    SQL

    remove_column :jira_issues, :jira_project_id

    drop_table :jira_projects
  end

  def down
    create_table :jira_projects do |t|
      t.references :product, foreign_key: true
      t.string :jira_project_key, null: false
      t.string :project_name
      t.timestamps null: false
    end

    change_table :jira_issues do |t|
      t.references :jira_project, foreign_key: true
    end

    remove_column :jira_issues, :product_id
  end
end
