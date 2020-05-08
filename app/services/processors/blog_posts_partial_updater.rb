module Processors
  class BlogPostsPartialUpdater < BlogPostsUpdater
    def blog_posts
      starting_date = BlogPost.last&.published_at
      wordpress_service.blog_posts(since: starting_date)
    end
  end
end
