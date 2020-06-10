module Processors
  class BlogTechnologyViewsUpdater < BaseService
    def call
      blog_views_by_technology_and_month.each do |pair_group, visits|
        timestamp, technology_id = pair_group
        update_technology_visits_metric(technology_id, visits, timestamp)
      end
    end

    private

    def blog_views_by_technology_and_month
      metrics_by_timestamp
        .where(name: Metric.names[:blog_visits], ownable_type: BlogPost.to_s)
        .joins('JOIN blog_posts on metrics.ownable_id = blog_posts.id')
        .group(:value_timestamp, :technology_id)
        .sum(:value)
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
