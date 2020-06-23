class CreateLanguages < ActiveRecord::Migration[6.0]
  def change
    create_table :languages do |t|
      t.string :name
      t.references :department, null: true, foreign_key: true
    end
  end
end
