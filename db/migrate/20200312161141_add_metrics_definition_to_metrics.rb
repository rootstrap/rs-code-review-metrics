class AddMetricsDefinitionToMetrics < ActiveRecord::Migration[6.0]
  def change
    add_reference :metrics, :metrics_definition, null: false, foreign_key: true
  end
end
