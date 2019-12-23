class AddGithubIdToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :github_id, :bigint
  end
end
