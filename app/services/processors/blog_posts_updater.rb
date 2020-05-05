module Processors
  class BlogPostsUpdater
    def call
      wordpress_service.blog_posts.each do |blog_post|
        BlogPost.create_with(
          published_at: blog_post[:date],
          slug: blog_post[:slug],
          status: blog_post[:status],
          url: blog_post[:URL],
          technology: categorizer.technology_for(blog_post)
        ).find_or_create_by!(blog_id: blog_post[:ID])
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
