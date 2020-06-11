class CreateCodeOwnerProjects < ActiveRecord::Migration[6.0]
  def change
    create_table :code_owner_projects do |t|
      t.references :project, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
