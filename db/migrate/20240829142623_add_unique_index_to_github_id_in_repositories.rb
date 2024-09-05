class AddUniqueIndexToGithubIdInRepositories < ActiveRecord::Migration[7.1]
  def change
    add_index :repositories, :github_id, unique: true
  end
end
