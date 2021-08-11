class AddDeletedAndTimestampToProduct < ActiveRecord::Migration[6.0]
  def change
    change_table :products, bulk: true do |t|
      t.timestamps null: true
      t.datetime :deleted_at, index: true
    end

    Product.update_all(created_at: Time.zone.now, updated_at: Time.zone.now)
  end
end
