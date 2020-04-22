class AddProjectToPullRequest < ActiveRecord::Migration[6.0]
  def change
    add_reference :pull_requests, :project, foreign_key: true
  end
end
