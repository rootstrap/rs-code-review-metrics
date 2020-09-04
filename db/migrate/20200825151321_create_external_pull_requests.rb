class CreateExternalPullRequests < ActiveRecord::Migration[6.0]
  def change
    create_table :external_pull_requests do |t|
      t.text :body
      t.string :html_url, null: false
      t.text :title
      t.bigint :github_id
      t.references :owner, foreign_key: { to_table: :users }
      t.references :external_project, null: false, foreign_key: true

      t.timestamps
    end
  end
end
