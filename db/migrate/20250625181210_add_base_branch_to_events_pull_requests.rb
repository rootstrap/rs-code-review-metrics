class AddBaseBranchToEventsPullRequests < ActiveRecord::Migration[7.1]
  def change
    add_column :events_pull_requests, :base_branch, :string
  end
end
