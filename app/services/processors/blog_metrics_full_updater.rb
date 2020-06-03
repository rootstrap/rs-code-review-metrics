module Processors
  class BlogMetricsFullUpdater < BlogMetricsUpdater
    private

    def technology_views_updater
      BlogTechnologyViewsFullUpdater
    end
  end
end
