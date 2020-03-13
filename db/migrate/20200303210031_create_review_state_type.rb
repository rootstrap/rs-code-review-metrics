class CreateReviewStateType < ActiveRecord::Migration[6.0]
  def change
    execute <<-SQL
      CREATE TYPE review_state AS ENUM ('approved', 'commented', 'changes_requested', 'dismissed');
    SQL

    add_column :reviews, :state, :review_state, null: false
    add_index :reviews, :state
  end
end
