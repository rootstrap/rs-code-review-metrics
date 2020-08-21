module Processors
  class BlogMetricsPartialUpdater < BlogMetricsUpdater
    private

    def technology_views_updater
      BlogTechnologyViewsPartialUpdater
    end
  end
end
