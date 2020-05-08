class ChangePublishedAtToBeDatetimeInBlogPosts < ActiveRecord::Migration[6.0]
  def up
    change_column :blog_posts, :published_at, :datetime
  end

  def down
    change_column :blog_posts, :published_at, :date
  end
end
