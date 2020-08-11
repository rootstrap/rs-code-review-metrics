module Builders
  module MetricChart
    module Blog
      class TechnologyBlogPostCount < Builders::MetricChart::Blog::Base
        def metric_name
          Metric.names[:blog_post_count]
        end

        def entity_metrics(technology)
          technology.blog_posts
        end

        def totals_metrics
          BlogPost.all
        end

        def collect_data(blog_posts)
          blog_posts
            .group_by_period(grouping_period, :published_at, last: periods)
            .count
        end
      end
    end
  end
end
