class AddNotNullBooleansToPullRequest < ActiveRecord::Migration[6.0]
  def change
    change_column_null :pull_requests, :locked, false, false
    change_column_null :pull_requests, :merged, false, false
    change_column_null :pull_requests, :draft, false, false
    change_column_null :pull_requests, :locked, false, false
  end
end
