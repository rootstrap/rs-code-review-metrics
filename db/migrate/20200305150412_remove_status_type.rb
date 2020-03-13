class RemoveStatusType < ActiveRecord::Migration[6.0]
  def up
    remove_column :review_requests, :status
    remove_column :review_comments, :status
    execute <<-SQL
      DROP TYPE status;
    SQL
  end

  def down
    execute <<-SQL
      CREATE TYPE status AS ENUM ('active', 'removed');
    SQL
    add_column :review_requests, :status
    add_column :review_comments, :status
  end
end
