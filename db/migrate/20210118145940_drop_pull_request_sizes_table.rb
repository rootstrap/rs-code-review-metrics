class DropPullRequestSizesTable < ActiveRecord::Migration[6.0]
  def change
    drop_table :pull_request_sizes
  end
end
