class AddEnabledToProducts < ActiveRecord::Migration[6.0]
  def change
    change_table :products do |t|
      t.boolean :enabled, null: false, default: true
    end

    add_index :products, :enabled
  end
end
