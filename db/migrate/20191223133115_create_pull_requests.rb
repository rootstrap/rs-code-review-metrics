class CreatePullRequests < ActiveRecord::Migration[6.0]
  def change
    create_table :pull_requests do |t|
      t.integer :github_id
      t.integer :number
      t.string :state
      t.boolean :locked
      t.text :title
      t.text :body
      t.datetime :closed_at
      t.datetime :merged_at
      t.boolean :draft
      t.boolean :merged
      t.string :node_id
      t.timestamps
    end
  end
end
