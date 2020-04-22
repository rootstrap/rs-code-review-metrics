class AddIntervalAndNameToMetrics < ActiveRecord::Migration[6.0]
  def change
    execute <<-SQL
      CREATE TYPE metric_name AS ENUM ('review_turnaround');
    SQL

    execute <<-SQL
      CREATE TYPE metric_interval AS ENUM ('daily', 'weekly', 'monthly', 'all_times');
    SQL

    add_column :metrics, :name, :metric_name
    add_column :metrics, :interval, :metric_interval
  end
end
