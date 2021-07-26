class AddReferenceToPullRequestCommment < ActiveRecord::Migration[6.0]
  def change
    add_reference :pull_request_comments, :review_request
  end
end
