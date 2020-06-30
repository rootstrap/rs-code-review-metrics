class RemoveLangFromProjects < ActiveRecord::Migration[6.0]
  def change
    remove_column :projects, :lang
  end
end
