class ChangeReviewCommentsStatus < ActiveRecord::Migration[6.0]
  def up
    execute <<-SQL
      CREATE TYPE review_comment_state AS ENUM ('active', 'removed');
    SQL
    add_column :review_comments, :state, :review_comment_state, default: 'active'
    add_index :review_comments, :state
  end

  def down
    remove_index :review_comments, :state
    remove_column :review_comments, :state
    execute <<-SQL
      DROP TYPE review_request_state;
    SQL
  end
end
