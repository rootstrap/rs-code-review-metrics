class CreateFileIgnoringRules < ActiveRecord::Migration[6.0]
  def change
    create_table :file_ignoring_rules do |t|
      t.references :language, null: false, foreign_key: true
      t.string :regex, null: false

      t.timestamps
    end
  end
end
