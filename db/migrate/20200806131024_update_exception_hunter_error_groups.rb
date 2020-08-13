class UpdateExceptionHunterErrorGroups < ActiveRecord::Migration[6.0]
  def change
    change_table :exception_hunter_error_groups, bulk: true do |t|
      t.integer :status, default: 0
      t.text :tags, array: true, default: []

      t.index :status
    end
  end
end
