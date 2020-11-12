module Processors
  class BlogPostsUpdater < BaseService
    def call
      blog_posts.each do |blog_post_payload|
        blog_post = BlogPost.find_or_initialize_by(blog_id: blog_post_payload[:ID])
        blog_post.published_at = blog_post_payload[:date]
        blog_post.slug = blog_post_payload[:slug]
        blog_post.status = blog_post_payload[:status]
        blog_post.url = blog_post_payload[:URL]
        if blog_post.technologies.empty?
          blog_post.technologies = technologies_for(blog_post_payload)
        end

        blog_post.save!
      end
    end

    private

    def wordpress_service
      @wordpress_service ||= WordpressService.new
    end

    def categorizer
      @categorizer ||= BlogPostCategorizer.new
    end

    def technologies_for(blog_post_payload)
      categorizer.technologies_for(blog_post_payload)
    end
  end
end
