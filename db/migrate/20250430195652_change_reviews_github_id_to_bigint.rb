class ChangeReviewsGithubIdToBigint < ActiveRecord::Migration[7.1]
  def change
    change_column :events_reviews, :github_id, :bigint
  end
end
