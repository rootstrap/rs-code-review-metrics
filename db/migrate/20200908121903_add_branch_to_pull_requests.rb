class AddBranchToPullRequests < ActiveRecord::Migration[6.0]
  def change
    add_column :pull_requests, :branch, :string
  end
end
