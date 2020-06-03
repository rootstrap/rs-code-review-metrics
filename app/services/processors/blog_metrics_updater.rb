module Processors
  class BlogMetricsUpdater < BaseService
    def call
      update_blog_post_visits_metrics
      update_technologies_visits_metrics
    end

    private

    def update_blog_post_visits_metrics
      BlogPost.find_each(batch_size: 50).lazy.each do |blog_post|
        BlogPostViewsUpdater.call(blog_post.blog_id)
      end
    end

    def update_technologies_visits_metrics
      technology_views_updater.call
    end
  end
end
