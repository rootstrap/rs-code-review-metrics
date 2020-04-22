class DeleteStatusFromReviews < ActiveRecord::Migration[6.0]
  def change
    remove_column :reviews, :status
  end
end
