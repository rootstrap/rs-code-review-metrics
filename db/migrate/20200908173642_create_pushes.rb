class CreatePushes < ActiveRecord::Migration[6.0]
  def change
    create_table :pushes do |t|
      t.references :project, null: false, foreign_key: true
      t.references :pull_request, null: true, foreign_key: true
      t.references :sender, null: false, foreign_key: { to_table: :users }
      t.string :ref

      t.timestamps
    end
  end
end
