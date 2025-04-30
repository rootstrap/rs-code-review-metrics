class ChangeReviewCommentsGithubIdToBigint < ActiveRecord::Migration[7.1]
  def change
    change_column :events_review_comments, :github_id, :bigint
  end
end
