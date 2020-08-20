class DeleteTechnologyIdColumnInBlogPosts < ActiveRecord::Migration[6.0]
  def change
    remove_reference :blog_posts, :technology, foreign_key: true, index: true
  end
end
