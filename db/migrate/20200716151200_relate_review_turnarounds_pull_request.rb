class RelateReviewTurnaroundsPullRequest < ActiveRecord::Migration[6.0]
  def up
    remove_reference :review_turnarounds, :review_request
    add_reference :review_turnarounds, :pull_request, foreign_key: true
  end

  def down
    remove_reference :review_turnarounds, :pull_request
    add_reference :review_turnarounds, :review_request, foreign_key: true
  end
end
