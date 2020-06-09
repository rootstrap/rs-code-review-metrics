module Processors
  class BlogMetricsFullUpdater < BlogMetricsUpdater
    private

    def technology_views_updater
      BlogTechnologyViewsFullUpdater
    end

    def blog_post_count_updater
      BlogPostCountMetricsFullUpdater
    end
  end
end
