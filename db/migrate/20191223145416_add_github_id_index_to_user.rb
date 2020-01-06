class AddGithubIdIndexToUser < ActiveRecord::Migration[6.0]
  def change
    add_index :users, :github_id, unique: true
  end
end
