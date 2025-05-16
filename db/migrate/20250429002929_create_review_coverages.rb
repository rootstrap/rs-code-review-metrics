class CreateReviewCoverages < ActiveRecord::Migration[7.1]
  def change
    create_table :review_coverages do |t|
      t.references :pull_request, null: false, foreign_key: { to_table: :events_pull_requests }
      t.integer :total_files_changed, null: false
      t.integer :files_with_comments_count, null: false
      t.decimal :coverage_percentage, null: false
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
