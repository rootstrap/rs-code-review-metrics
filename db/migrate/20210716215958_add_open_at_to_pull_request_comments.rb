class AddOpenAtToPullRequestComments < ActiveRecord::Migration[6.0]
  def change
    add_column :pull_request_comments, :opened_at, :datetime, null: false
  end
end
