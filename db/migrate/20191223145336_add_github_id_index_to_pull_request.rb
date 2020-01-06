class AddGithubIdIndexToPullRequest < ActiveRecord::Migration[6.0]
  def change
    add_index :pull_requests, :github_id, unique: true
  end
end
