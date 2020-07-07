class CreateReviewTurnarounds < ActiveRecord::Migration[6.0]
  def change
    create_table :review_turnarounds do |t|
      t.references :review_request, null: false, foreign_key: true
      t.integer :value
    end
  end
end
