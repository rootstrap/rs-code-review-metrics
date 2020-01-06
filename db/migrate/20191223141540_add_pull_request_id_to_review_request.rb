class AddPullRequestIdToReviewRequest < ActiveRecord::Migration[6.0]
  def change
    add_reference :review_requests, :pull_request, null: false, foreign_key: true
  end
end
