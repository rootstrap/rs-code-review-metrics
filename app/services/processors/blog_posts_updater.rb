module Processors
  class BlogPostsUpdater < BaseService
    def call
      blog_posts.each do |blog_post_payload|
        blog_post = find_or_initialize_blog_post(blog_post_payload)
        set_blog_post_attributes(blog_post, blog_post_payload)
        set_technologies(blog_post, blog_post_payload)

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

    def find_or_initialize_blog_post(blog_post_payload)
      BlogPost.find_or_initialize_by(blog_id: blog_post_payload[:ID])
    end

    def set_blog_post_attributes(blog_post, blog_post_payload)
      blog_post.published_at = blog_post_payload[:date]
      blog_post.slug = blog_post_payload[:slug]
      blog_post.status = blog_post_payload[:status]
      blog_post.url = blog_post_payload[:URL]
    end

    def set_technologies(blog_post, blog_post_payload)
      blog_post.technologies = technologies_for(blog_post_payload) if blog_post.technologies.empty?
    end

    def technologies_for(blog_post_payload)
      categorizer.technologies_for(blog_post_payload)
    end
  end
end
