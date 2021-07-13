class JiraProjectsAddProductReference < ActiveRecord::Migration[6.0]
  def change
    change_table :jira_projects do |t|
      t.references :product, foreign_key: true
    end
  end
end
