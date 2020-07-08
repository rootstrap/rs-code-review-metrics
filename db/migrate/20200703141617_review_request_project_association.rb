class ReviewRequestProjectAssociation < ActiveRecord::Migration[6.0]
  def change
    add_reference :review_requests, :project, foreign_key: true
  end
end
