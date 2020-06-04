module Processors
  class BlogMetricsPartialUpdater < BlogMetricsUpdater
    private

    def technology_views_updater
      BlogTechnologyViewsPartialUpdater
    end

    def blog_post_count_updater
      BlogPostCountMetricsPartialUpdater
    end
  end
end
