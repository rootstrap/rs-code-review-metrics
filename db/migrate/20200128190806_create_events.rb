class CreateEvents < ActiveRecord::Migration[6.0]
  def change
    create_table :events, force: :cascade do |t|
      t.references :handleable, polymorphic: true, index: true
      t.string :name
      t.string :type
      t.jsonb :data

      t.timestamps
    end
  end
end
