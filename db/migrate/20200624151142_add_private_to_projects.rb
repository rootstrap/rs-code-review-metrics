class AddPrivateToProjects < ActiveRecord::Migration[6.0]
  def change
    add_column :projects, :private, :boolean
  end
end
