class AddDailyDefaultToMetrics < ActiveRecord::Migration[6.0]
  def change
    change_column_default(:metrics, :interval, 'daily')
  end
end
