class CreateMergeTimes < ActiveRecord::Migration[6.0]
  def change
    create_table :merge_times do |t|
      t.references :pull_request, null: false, foreign_key: true
      t.integer :value

      t.timestamps
    end
  end
end
