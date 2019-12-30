class RemoveTypeFromUser < ActiveRecord::Migration[6.0]
  def change
    remove_column :users, :type, :string
  end
end
