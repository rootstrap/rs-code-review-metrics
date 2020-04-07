class AddOwnableToMetrics < ActiveRecord::Migration[6.0]
  def change
    add_reference :metrics, :ownable, polymorphic: true, null: false
  end
end
