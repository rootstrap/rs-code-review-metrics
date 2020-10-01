class ChangeColumnSnapshotTimeInCodeClimateProjectMetric < ActiveRecord::Migration[6.0]
  def change
    change_column_null :code_climate_project_metrics, :snapshot_time, true
  end
end
