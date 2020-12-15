class AddEnabledToExternalProject < ActiveRecord::Migration[6.0]
  def change
    add_column :external_projects, :enabled, :boolean, default: true, null: false
  end
end
