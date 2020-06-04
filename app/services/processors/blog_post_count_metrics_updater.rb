module Processors
  class BlogPostCountMetricsUpdater < BaseService
    def call
      Technology.all.each do |technology|
        new_blog_posts_by_month_for(technology).each do |month, new_blog_post_count|
          timestamp = month.to_time.utc
          cumulative_blog_post_count = new_blog_post_count +
                                       registered_blog_count_for(technology, timestamp.last_month)

          create_or_update_blog_post_count_metric(
            technology,
            timestamp,
            cumulative_blog_post_count
          )
        end
      end
    end

    private

    def new_blog_posts_by_month_for(technology)
      technology
        .blog_posts
        .group_by_month(:published_at, range: starting_time_to_update(technology)..Time.zone.now)
        .count
    end

    def first_publication_time
      BlogPost.pluck(:published_at).min
    end

    def create_or_update_blog_post_count_metric(technology, timestamp, blog_post_count)
      metric = Metric.find_or_initialize_by(
        name: Metric.names[:blog_post_count],
        interval: Metric.intervals[:monthly],
        ownable: technology,
        value_timestamp: timestamp.end_of_month
      )
      metric.value = blog_post_count
      metric.save!
    end

    def registered_blog_count_for(technology, timestamp)
      metric = Metric.find_by(
        name: Metric.names[:blog_post_count],
        interval: Metric.intervals[:monthly],
        ownable: technology,
        value_timestamp: timestamp.end_of_month
      )
      metric&.value || 0
    end
  end
end