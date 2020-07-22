class AddLangsToProjects < ActiveRecord::Migration[6.0]
  disable_ddl_transaction!

  def up
    execute <<-SQL
      ALTER TYPE lang ADD VALUE 'vuejs';
      ALTER TYPE lang ADD VALUE 'react_native';
    SQL
  end

  def down
    execute <<-SQL
      ALTER TYPE lang RENAME TO lang_old;
      CREATE TYPE lang AS ENUM ('ruby', 'python', 'nodejs', 'react', 'ios', 'android', 'others', 'unassigned');
      ALTER TABLE projects ALTER COLUMN lang TYPE lang USING name::text::lang;
      DROP TYPE lang_old;
    SQL
  end
end
