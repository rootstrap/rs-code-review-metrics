class CreateRepositories < ActiveRecord::Migration[6.0]
  def change
    create_table :repositories do |t|
      t.string :action
      t.string :html_url
      t.timestamps
      t.references :sender, null: false, foreign_key: { to_table: :users }
      t.references :project, null: false, foreign_key: true
    end
  end
end
