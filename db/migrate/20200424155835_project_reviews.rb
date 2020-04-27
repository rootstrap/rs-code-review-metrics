class ProjectReviews < ActiveRecord::Migration[6.0]
  def change
    add_reference :reviews, :project
  end
end
