class AddOcurredAtToEvents < ActiveRecord::Migration[6.0]
  def change
    add_column :events, :occurred_at, :datetime, null: true
    add_index :events, :occurred_at
  end
end
