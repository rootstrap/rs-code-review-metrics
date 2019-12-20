class CreateReviewRequests < ActiveRecord::Migration[6.0]
  def change
    create_table :review_requests do |t|
      t.text :data

      t.timestamps
    end
  end
end
