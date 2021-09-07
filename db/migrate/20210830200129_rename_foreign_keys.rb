class RenameForeignKeys < ActiveRecord::Migration[6.0]
  def change
    rename_column      :events, :project_id, :repository_id
    add_foreign_key    :events, :repositories

    rename_column      :events_pull_requests, :project_id, :repository_id
    add_foreign_key    :events_pull_requests, :repositories

    rename_column      :events_reviews, :project_id, :repository_id
    add_foreign_key    :events_reviews, :repositories

    rename_column      :review_requests, :project_id, :repository_id
    add_foreign_key    :review_requests, :repositories

    rename_column      :events_repositories, :project_id, :repository_id
    add_foreign_key    :events_repositories, :repositories

    rename_column      :users_projects, :project_id, :repository_id
    add_foreign_key    :users_projects, :repositories

    rename_column      :code_owner_projects, :project_id, :repository_id
    add_foreign_key    :code_owner_projects, :repositories

    rename_column      :code_climate_project_metrics, :project_id, :repository_id
    add_foreign_key    :code_climate_project_metrics, :repositories

    rename_column      :events_pushes, :project_id, :repository_id
    add_foreign_key    :events_pushes, :repositories
  end
end
