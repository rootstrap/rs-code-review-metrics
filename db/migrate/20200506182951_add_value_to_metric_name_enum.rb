class AddValueToMetricNameEnum < ActiveRecord::Migration[6.0]
  def up
    execute <<-SQL
      ALTER TYPE metric_name ADD VALUE 'merge_time';
    SQL
  end

  def down
    execute <<-SQL
      ALTER TYPE metric_name RENAME TO metric_name_old;
      CREATE TYPE metric_name AS ENUM ('review_turnaround', 'blog_visits');
      ALTER TABLE metrics ALTER COLUMN name TYPE metric_name USING name::text::metric_name;
      DROP TYPE metric_name_old;
    SQL
  end
end
