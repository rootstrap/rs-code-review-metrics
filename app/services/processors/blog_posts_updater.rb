module Processors
  class BlogPostsUpdater < BaseService
    def initialize(full_update: false)
      @full_update = full_update
    end

    def call
      blog_posts.each do |blog_post_payload|
        blog_post = BlogPost.find_or_initialize_by(blog_id: blog_post_payload[:ID])
        blog_post.published_at = blog_post_payload[:date]
        blog_post.slug = blog_post_payload[:slug]
        blog_post.status = blog_post_payload[:status]
        blog_post.url = blog_post_payload[:URL]
        blog_post.technology = categorizer.technology_for(blog_post_payload)

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

    def full_update?
      @full_update
    end

    def blog_posts
      starting_date = BlogPost.last&.published_at unless full_update?

      wordpress_service.blog_posts(since: starting_date)
    end
  end
end
