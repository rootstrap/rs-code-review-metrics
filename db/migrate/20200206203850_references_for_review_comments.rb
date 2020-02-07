class ReferencesForReviewComments < ActiveRecord::Migration[6.0]
  def change
    add_reference :review_comments, :pull_request, null: false, foreign_key: true
    add_reference :review_comments, :owner, foreign_key: { to_table: :users }
  end
end
