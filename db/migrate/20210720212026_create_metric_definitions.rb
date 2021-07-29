class CreateMetricDefinitions < ActiveRecord::Migration[6.0]
  def change
    create_table :metric_definitions do |t|
      t.string :name, null: false
      t.string :explanation, null: false

      t.timestamps
    end

    add_column :metric_definitions, :code, :metric_name, null: false
  end
end
