module Processors
  class BlogPostsUpdater
    def call
      wordpress_service.blog_posts.each do |blog_post|
        BlogPost.create!(
          published_at: blog_post[:date],
          slug: blog_post[:slug],
          status: blog_post[:status],
          url: blog_post[:URL],
          blog_id: blog_post[:ID],
          technology: categorizer.technology_for(blog_post)
        )
      end
    end

    private

    def wordpress_service
      @wordpress_service ||= WordpressService.new
    end

    def categorizer
      @categorizer ||= BlogPostCategorizer.new
    end
  end
end
