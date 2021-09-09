class ChangeMetricOwnableType < ActiveRecord::Migration[6.0]
  def up
    Metric.where(ownable_type: 'Project').update_all(ownable_type: 'Repository')
  end

  def down
    Metric.where(ownable_type: 'Repository').update_all(ownable_type: 'Project')
  end
end
