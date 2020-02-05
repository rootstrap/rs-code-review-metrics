class CreateProjects < ActiveRecord::Migration[6.0]
  def change
    create_table :projects do |t|
      t.integer :github_id, null: false
      t.string :name
      t.string :description

      t.timestamps
    end
  end
end
