module Processors
  class BlogPostCountMetricsFullUpdater < BlogPostCountMetricsUpdater
    private

    def starting_time_to_update(_technology)
      first_publication_time
    end
  end
end
