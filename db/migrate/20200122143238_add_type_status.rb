class AddTypeStatus < ActiveRecord::Migration[6.0]
  def change
    execute <<-SQL
      CREATE TYPE status AS ENUM ('active', 'removed');
    SQL

    add_column :review_requests, :status, :status
  end
end
