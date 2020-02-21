class CreateReviews < ActiveRecord::Migration[6.0]
  def change
    create_table :reviews do |t|
      t.references :pull_request, null: false, foreign_key: true
      t.references :owner, foreign_key: { to_table: :users }
      t.integer :github_id
      t.string :body

      t.timestamps
    end
    add_column :reviews, :status, :status, default: 'active'
  end
end
