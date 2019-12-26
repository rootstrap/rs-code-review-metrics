class JsonbDataToReviewRequest < ActiveRecord::Migration[6.0]
  def up
    change_column :review_requests, :data, :jsonb, using: 'CAST("data" AS JSON)'
  end

  def down
    change_column :review_requests, :data, :text
  end
end
