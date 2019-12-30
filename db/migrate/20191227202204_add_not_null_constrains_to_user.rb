class AddNotNullConstrainsToUser < ActiveRecord::Migration[6.0]
  def change
    change_column_null :users, :github_id, false
    change_column_null :users, :type, false
    change_column_null :users, :login, false
    change_column_null :users, :node_id, false
  end
end
