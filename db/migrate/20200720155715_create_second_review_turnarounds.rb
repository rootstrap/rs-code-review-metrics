class CreateSecondReviewTurnarounds < ActiveRecord::Migration[6.0]
  def change
    create_table :second_review_turnarounds do |t|
      t.references :review_request, null: false, foreign_key: true
      t.integer :value

      t.timestamps
    end
  end
end
