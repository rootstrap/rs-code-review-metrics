class CreateExternalProjects < ActiveRecord::Migration[6.0]
  def change
    create_table :external_projects do |t|
      t.string :description
      t.string :name
      t.string :full_name, null: false
      t.bigint :github_id, null: false
      t.references :language

      t.timestamps
    end
  end
end
