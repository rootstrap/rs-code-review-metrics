class RemoveDeletedAtToEvents < ActiveRecord::Migration[6.0]
  def change
    remove_column :events, :deleted_at
    remove_column :events_pull_request_comments, :deleted_at
    remove_column :events_pull_requests, :deleted_at
    remove_column :events_pushes, :deleted_at
    remove_column :events_repositories, :deleted_at
    remove_column :events_review_comments, :deleted_at
    remove_column :events_reviews, :deleted_at
  end
end
