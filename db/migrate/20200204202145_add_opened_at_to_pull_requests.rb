class AddOpenedAtToPullRequests < ActiveRecord::Migration[6.0]
  def change
    add_column :pull_requests, :opened_at, :datetime
  end
end
