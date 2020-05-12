module Processors
  class BlogPostsFullUpdater < BlogPostsUpdater
    delegate :blog_posts, to: :wordpress_service
  end
end
