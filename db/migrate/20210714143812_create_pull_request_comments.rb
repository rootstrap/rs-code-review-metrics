class CreatePullRequestComments < ActiveRecord::Migration[6.0]
  def change
    create_table :pull_request_comments do |t|
      t.integer :github_id
      t.string :body

      t.timestamps
    end
  end
end
