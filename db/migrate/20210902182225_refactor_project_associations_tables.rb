class RefactorProjectAssociationsTables < ActiveRecord::Migration[6.0]
  def change
    rename_table :code_climate_project_metrics, :code_climate_repository_metrics
    rename_table :code_owner_projects, :code_owner_repositories
    rename_table :external_projects, :external_repositories
    rename_table :users_projects, :users_repositories

    rename_column      :external_pull_requests, :external_project_id, :external_repository_id
    add_foreign_key    :external_pull_requests, :external_repositories
  end
end
