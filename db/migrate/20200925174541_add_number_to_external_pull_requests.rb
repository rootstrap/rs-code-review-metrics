class AddNumberToExternalPullRequests < ActiveRecord::Migration[6.0]
  def change
    add_column :external_pull_requests, :number, :integer
  end
end
