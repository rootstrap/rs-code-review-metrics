class AddCcRepositoryIdToCodeClimateProjectMetrics < ActiveRecord::Migration[6.0]
  def change
    add_column :code_climate_project_metrics, :cc_repository_id, :string
  end
end
