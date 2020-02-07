class DeleteMergedFromPullRequest < ActiveRecord::Migration[6.0]
  def change
    remove_column :pull_requests, :merged
  end
end
