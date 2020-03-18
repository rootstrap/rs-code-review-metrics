class AddOpenedAtToReviews < ActiveRecord::Migration[6.0]
  def change
    add_column :reviews, :opened_at, :datetime, null: false
  end
end
