class CreateJiraEnvironments < ActiveRecord::Migration[6.0]
  def change
    create_table :jira_environments do |t|
      t.string :custom_environment
      t.references :jira_board, foreign_key: true
      t.datetime :deleted_at
    end
    add_column :jira_environments, :environment, :environment, null: false
  end
end
