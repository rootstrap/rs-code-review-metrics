class CreateMetrics < ActiveRecord::Migration[6.0]
  def change
    create_table :metrics do |t|
      t.string :entity_key,         null: false
      t.string :metric_key,         null: false
      t.decimal :value,             null: true
      t.datetime :value_timestamp,  null: true

      t.timestamps
    end
  end
end
