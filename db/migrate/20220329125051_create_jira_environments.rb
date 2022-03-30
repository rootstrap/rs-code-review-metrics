class CreateJiraEnvironments < ActiveRecord::Migration[6.0]
  def change
    create_table :jira_environments do |t|
      t.string :custom_environment
      t.integer :standard_environment
      t.references :jira_board, null: false, foreign_key: true
    end
  end
end
