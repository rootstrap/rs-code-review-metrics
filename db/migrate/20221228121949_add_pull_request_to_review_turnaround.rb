class AddPullRequestToReviewTurnaround < ActiveRecord::Migration[6.0]
  def change
    add_reference :review_turnarounds, :pull_request, foreign_key: { to_table: :events_pull_requests }
  end
end
