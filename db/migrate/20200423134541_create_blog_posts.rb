class CreateBlogPosts < ActiveRecord::Migration[6.0]
  def change
    create_table :blog_posts do |t|
      t.integer :blog_id
      t.string :slug
      t.date :published_at
      t.string :url
      t.string :status

      t.timestamps
    end
  end
end
