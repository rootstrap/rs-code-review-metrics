class AddIsPrivateToProjects < ActiveRecord::Migration[6.0]
  def change
    add_column :projects, :is_private, :boolean
  end
end
