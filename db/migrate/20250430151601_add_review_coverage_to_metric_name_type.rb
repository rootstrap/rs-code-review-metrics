class AddReviewCoverageToMetricNameType < ActiveRecord::Migration[7.1]
  disable_ddl_transaction!

  def up
    execute <<-SQL
      ALTER TYPE metric_name ADD VALUE 'review_coverage';
    SQL
  end

  def down
    execute <<-SQL
      ALTER TYPE metric_name RENAME TO metric_name_old;
      CREATE TYPE metric_name AS ENUM ('review_turnaround', 'blog_visits', 'merge_time', 'blog_post_count', 'open_source_visits', 'defect_escape_rate', 'pull_request_size', 'development_cycle');
      ALTER TABLE metrics ALTER COLUMN name TYPE metric_name USING name::text::metric_name;
      DROP TYPE metric_name_old;
    SQL
  end
end
