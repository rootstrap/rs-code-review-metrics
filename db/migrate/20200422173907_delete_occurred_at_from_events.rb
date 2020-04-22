class DeleteOccurredAtFromEvents < ActiveRecord::Migration[6.0]
  def change
    remove_index :events, :occurred_at
    remove_column :events, :occurred_at
  end
end
