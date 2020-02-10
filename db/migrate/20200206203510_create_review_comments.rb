class CreateReviewComments < ActiveRecord::Migration[6.0]
  def change
    create_table :review_comments do |t|
      t.integer :github_id
      t.string :body

      t.timestamps
    end

    add_column :review_comments, :status, :status, default: 'active'
  end
end
