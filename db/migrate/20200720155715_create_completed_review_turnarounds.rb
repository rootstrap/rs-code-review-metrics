class CreateCompletedReviewTurnarounds < ActiveRecord::Migration[6.0]
  def change
    create_table :completed_review_turnarounds do |t|
      t.references :review_request, null: false, foreign_key: true
      t.integer :value

      t.timestamps
    end
  end
end
