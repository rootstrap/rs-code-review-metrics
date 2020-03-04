class CreateReviewStateType < ActiveRecord::Migration[6.0]
  def change
    execute <<-SQL
      CREATE TYPE review_state AS ENUM ('approved', 'commented', 'changes_requested');
    SQL

    add_column :reviews, :review_state, :review_state, null: false
  end
end
