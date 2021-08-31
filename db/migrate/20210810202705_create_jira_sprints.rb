class CreateJiraSprints < ActiveRecord::Migration[6.0]
  def change
    create_table :jira_sprints do |t|
      t.integer :jira_id, null: false
      t.string :name

      t.integer :points_committed
      t.integer :points_completed

      t.datetime :started_at, null: false
      t.datetime :ended_at
      t.boolean :active
      t.datetime :deleted_at

      t.timestamps null: false

      t.references :jira_board, null: false, foreign_key: true
    end
  end
end
