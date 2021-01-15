class AddPullRequestSize < ActiveRecord::Migration[6.0]
  def change
    add_column :pull_requests, :size, :integer
  end
end
