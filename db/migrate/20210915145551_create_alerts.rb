class CreateAlerts < ActiveRecord::Migration[6.0]
  def change
    create_table :alerts do |t|
      t.string :name
      t.string :metric_name, null: false
      t.integer :threshold, null: false
      t.string :emails, array: true, default: [], null: false
      t.integer :frequency, null: false
      t.datetime :last_sent_date
      t.boolean :active, null: false, default: false

      t.timestamps

      t.references :repository, foreign_key: true
      t.references :department, foreign_key: true
    end
  end
end
