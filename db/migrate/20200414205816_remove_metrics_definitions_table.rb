class RemoveMetricsDefinitionsTable < ActiveRecord::Migration[6.0]
  def change
    change_table :metrics do |t|
      t.remove :metrics_definition_id
    end
    drop_table :metrics_definitions
  end
end
