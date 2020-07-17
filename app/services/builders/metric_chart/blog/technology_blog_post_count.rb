module Builders
  module MetricChart
    module Blog
      class TechnologyBlogPostCount < Builders::MetricChart::Blog::Base
        def metric_name
          Metric.names[:blog_post_count]
        end

        def calculate_totals
          {
            name: 'Totals',
            data: format_data(totals_data),
            dataset: { hidden: false }
          }
        end

        def totals_data
          blog_post_count_to_date = BlogPost.where('published_at < ?', period_start).count

          new_monthly_blog_posts.transform_values do |new_blog_post_count|
            blog_post_count_to_date += new_blog_post_count
          end
        end

        def new_monthly_blog_posts
          BlogPost
            .group_by_month(:published_at, range: period_start..Time.zone.now)
            .count
        end

        def period_start
          @period_start ||= periods.months.ago.beginning_of_month
        end
      end
    end
  end
end
