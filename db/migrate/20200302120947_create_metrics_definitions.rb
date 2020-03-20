class CreateMetricsDefinitions < ActiveRecord::Migration[6.0]
  def change
    create_table :metrics_definitions do |t|
      t.string :metrics_name, null: false
      t.string :time_interval, null: false # TODO: make it a Postgres enum
      t.string :subject, null: false # TODO: make it a Postgres enum
      t.string :metrics_processor, null: false
      t.datetime :last_processed_event_time, null: true

      t.timestamps
    end
  end
end
