class AddProjectToPullRequest < ActiveRecord::Migration[6.0]
  def change
    add_reference :pull_requests, :project, null: false, foreign_key: true
  end
end
