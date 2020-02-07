class AddLangEnum < ActiveRecord::Migration[6.0]
  def change
    execute <<-SQL
      CREATE TYPE lang AS ENUM ('ruby', 'python', 'nodejs', 'react', 'ios', 'android', 'others', 'unassigned');
    SQL

    add_column :projects, :lang, :lang, default: 'unassigned'
  end
end
