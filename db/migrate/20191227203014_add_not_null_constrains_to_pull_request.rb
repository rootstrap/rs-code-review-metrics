class AddNotNullConstrainsToPullRequest < ActiveRecord::Migration[6.0]
  def change
    change_column_null :pull_requests, :github_id, false
    change_column_null :pull_requests, :title, false
    change_column_null :pull_requests, :number, false
    change_column_null :pull_requests, :state, false
    change_column_null :pull_requests, :node_id, false
  end
end
