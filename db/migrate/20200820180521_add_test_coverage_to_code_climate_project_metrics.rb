class AddTestCoverageToCodeClimateProjectMetrics < ActiveRecord::Migration[6.0]
  def change
    add_column :code_climate_project_metrics, :test_coverage, :decimal
  end
end
