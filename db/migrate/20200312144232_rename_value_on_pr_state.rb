class RenameValueOnPrState < ActiveRecord::Migration[6.0]
  def up
    execute <<-SQL
      ALTER TYPE pull_request_state RENAME VALUE 'open' TO 'opened';
    SQL
  end

  def down
    execute <<-SQL
      ALTER TYPE pull_request_state RENAME VALUE 'opened' TO 'open';
    SQL
  end
end
