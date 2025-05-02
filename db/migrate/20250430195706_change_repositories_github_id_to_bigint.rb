class ChangeRepositoriesGithubIdToBigint < ActiveRecord::Migration[7.1]
  def change
    change_column :repositories, :github_id, :bigint
  end
end
