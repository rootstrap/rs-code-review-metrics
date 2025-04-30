class ChangePullRequestCommentsGithubIdToBigint < ActiveRecord::Migration[7.1]
  def change
    change_column :events_pull_request_comments, :github_id, :bigint
  end
end
