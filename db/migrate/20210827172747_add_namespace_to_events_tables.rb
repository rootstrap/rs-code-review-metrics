class AddNamespaceToEventsTables < ActiveRecord::Migration[6.0]
  def change
    rename_table :pull_requests, :events_pull_requests
    rename_table :pull_request_comments, :events_pull_request_comments
    rename_table :pushes, :events_pushes
    rename_table :repositories, :events_repositories
    rename_table :review_comments, :events_review_comments
    rename_table :reviews, :events_reviews
  end
end
