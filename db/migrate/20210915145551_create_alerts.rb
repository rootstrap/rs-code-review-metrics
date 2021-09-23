class CreateAlerts < ActiveRecord::Migration[6.0]
  def change
    create_table :alerts do |t|
      t.string :name
      t.string :metric_name
      t.integer :threshold
      t.string :emails
      t.integer :frequency
      t.datetime :last_sent_date
      t.boolean :active

      t.timestamps

      t.references :repository, foreign_key: true
      t.references :department, foreign_key: true
    end
  end
end
