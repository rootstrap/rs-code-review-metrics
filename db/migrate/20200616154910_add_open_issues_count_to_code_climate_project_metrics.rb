class AddOpenIssuesCountToCodeClimateProjectMetrics < ActiveRecord::Migration[6.0]
  def change
    add_column :code_climate_project_metrics, :open_issues_count, :integer
  end
end
