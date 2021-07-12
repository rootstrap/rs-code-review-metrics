class CreateProducts < ActiveRecord::Migration[6.0]
  def change
    create_table :products do |t|
      t.string :name, null: false
      t.string :description
      t.references :jira_project, foreign_key: true
    end

    add_index :products, :name
  end
end
