class AddDefaultValueToValueTimestamp < ActiveRecord::Migration[6.0]
  def change
    change_column_default :metrics, :value_timestamp, -> { 'CURRENT_TIMESTAMP' }
  end
end
