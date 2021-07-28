class CreatePullRequestComments < ActiveRecord::Migration[6.0]
  def change
    create_table :pull_request_comments, bulk: true do |t|
      t.integer :github_id
      t.string :body
      t.datetime :opened_at, null: false
      t.datetime :deleted_at, index: true

      t.timestamps

      t.references :pull_request, null: false, foreign_key: true
      t.references :owner, foreign_key: { to_table: :users }
      t.references :review_request
    end
  end
end
