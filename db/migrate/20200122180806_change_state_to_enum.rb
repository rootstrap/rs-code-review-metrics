class ChangeStateToEnum < ActiveRecord::Migration[6.0]
  def change
    execute <<-SQL
      CREATE TYPE state AS ENUM ('open', 'closed', 'merged');
    SQL

    remove_column :pull_requests, :state
    add_column :pull_requests, :state, :state
  end
end
