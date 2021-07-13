class AddDeletedAtToProjectsAndAssociations < ActiveRecord::Migration[6.0]
  def change
    add_column :projects, :deleted_at, :datetime, index: true
    add_column :events, :deleted_at, :datetime, index: true
    add_column :pull_requests, :deleted_at, :datetime, index: true
    add_column :review_comments, :deleted_at, :datetime, index: true
    add_column :pushes, :deleted_at, :datetime, index: true
    add_column :merge_times, :deleted_at, :datetime, index: true
    add_column :reviews, :deleted_at, :datetime, index: true
    add_column :review_requests, :deleted_at, :datetime, index: true
    add_column :completed_review_turnarounds, :deleted_at, :datetime, index: true
    add_column :users_projects, :deleted_at, :datetime, index: true
    add_column :metrics, :deleted_at, :datetime, index: true
    add_column :code_owner_projects, :deleted_at, :datetime, index: true
    add_column :code_climate_project_metrics, :deleted_at, :datetime, index: true
    add_column :jira_projects, :deleted_at, :datetime, index: true
    add_column :jira_issues, :deleted_at, :datetime, index: true
    add_column :repositories, :deleted_at, :datetime, index: true
  end
end
