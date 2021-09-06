class ChangeProjectsToRepositories < ActiveRecord::Migration[6.0]
  def change
    rename_table :projects, :repositories
  end
end
