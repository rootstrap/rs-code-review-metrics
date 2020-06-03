module Processors
  class BlogTechnologyViewsFullUpdater < BlogTechnologyViewsUpdater
    private

    def metrics_by_timestamp
      Metric.all
    end
  end
end
