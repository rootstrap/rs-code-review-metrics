class AddRelevanceToProjects < ActiveRecord::Migration[6.0]
  def up
    execute <<-SQL
      CREATE TYPE project_relevance AS ENUM ('commercial', 'internal', 'ignored', 'unassigned');
    SQL

    add_column :projects, :relevance, :project_relevance, index: true, null: false, default: 'unassigned'
  end

  def down
    remove_column :projects, :relevance

    execute <<-SQL
      DROP TYPE project_relevance;
    SQL
  end
end
