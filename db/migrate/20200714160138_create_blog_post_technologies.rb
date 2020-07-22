class CreateBlogPostTechnologies < ActiveRecord::Migration[6.0]
  def change
    create_table :blog_post_technologies do |t|
      t.references :blog_post, null: false, foreign_key: true, index: true
      t.references :technology, null: false, foreign_key: true, index: true

      t.timestamps
    end
  end
end
