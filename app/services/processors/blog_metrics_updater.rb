module Processors
  class BlogMetricsUpdater < BaseService
    def call
      update_blog_post_visits_metrics
      update_technologies_visits_metrics
    end

    private

    def update_blog_post_visits_metrics
      BlogPost.find_each(batch_size: 50) do |blog_post|
        BlogPostViewsUpdater.call(blog_post.blog_id)
      end
    end

    def update_technologies_visits_metrics
      blog_views_by_technology_and_month.each do |pair_group, visits|
        timestamp, technology_id = pair_group
        update_technology_visits_metric(technology_id, visits, timestamp)
      end
    end

    def blog_views_by_technology_and_month
      Metric.where(name: Metric.names[:blog_visits], ownable_type: BlogPost.to_s)
            .where('value_timestamp >= ?', latest_technology_metrics_updated_at)
            .joins('JOIN blog_posts on metrics.ownable_id = blog_posts.id')
            .group(:value_timestamp, :technology_id)
            .sum(:value)
    end

    def latest_technology_metrics_updated_at
      latest_visits_metrics_by_technology =
        Metric.where(name: Metric.names[:blog_visits], ownable_type: Technology.to_s)
              .group(:ownable_id)
              .maximum(:value_timestamp)

      latest_visits_metrics_by_technology.values.min || Time.zone.at(0)
    end

    def update_technology_visits_metric(technology_id, visits, timestamp)
      metric = Metric.find_or_initialize_by(
        ownable_id: technology_id,
        ownable_type: Technology.to_s,
        name: Metric.names[:blog_visits],
        interval: Metric.intervals[:monthly],
        value_timestamp: timestamp
      )
      metric.value = visits
      metric.save!
    end
  end
end
