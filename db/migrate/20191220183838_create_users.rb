class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :login
      t.string :node_id
      t.string :type

      t.timestamps
    end
  end
end
