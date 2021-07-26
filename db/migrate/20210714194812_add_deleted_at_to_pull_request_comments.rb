class AddDeletedAtToPullRequestComments < ActiveRecord::Migration[6.0]
  def change
    add_column :pull_request_comments, :deleted_at, :datetime, index: true
  end
end
