class RemoveEntityAndMetricKeyFromMetric < ActiveRecord::Migration[6.0]
  def change
    remove_column :metrics, :entity_key, :string
    remove_column :metrics, :metric_key, :string
  end
end
