module Processors
  class BlogPostCountMetricsRemover < Processors::Base
    private

    def process
      Metric.where(name: Metric.names[:blog_post_count]).destroy_all
    end
  end
end
