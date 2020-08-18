class AddHtmlUrlToPullRequests < ActiveRecord::Migration[6.0]
  def change
    add_column :pull_requests, :html_url, :string
  end
end
