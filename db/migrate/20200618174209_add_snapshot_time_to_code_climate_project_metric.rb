class AddSnapshotTimeToCodeClimateProjectMetric < ActiveRecord::Migration[6.0]
  def change
    add_column :code_climate_project_metrics, :snapshot_time, :datetime, null: false
  end
end
