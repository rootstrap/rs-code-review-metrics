class AddOpenedAtToExternalPullRequest < ActiveRecord::Migration[6.0]
  def change
    add_column :external_pull_requests, :opened_at, :datetime
  end
end
