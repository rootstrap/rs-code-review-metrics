module Processors
  class BlogPostViewsUpdater < BaseService
    def initialize(blog_post_id)
      @blog_post_id = blog_post_id
    end

    def call
      blog_post_views[:years].each do |year, year_hash|
        next if fully_registered_year?(year)

        year_hash[:months].each do |month, views|
          next if registered_month?(month, year)

          create_metric(year, month, views)
        end
      end
    end

    private

    attr_reader :blog_post_id

    def create_metric(year, month, views)
      metric = Metric.find_or_initialize_by(
        ownable: blog_post,
        name: Metric.names[:blog_visits],
        interval: Metric.intervals[:monthly],
        value_timestamp: Time.gm(year, month).end_of_month
      )
      metric.value = views
      metric.save!
    end

    def blog_post_views
      wordpress_service.blog_post_views(blog_post_id)
    end

    def fully_registered_year?(year)
      last_updated_metric.present? && last_updated_year > year.to_i
    end

    def registered_month?(month, year)
      last_updated_metric.present? &&
        last_updated_month > month.to_i &&
        last_updated_year == year.to_i
    end

    def last_updated_year
      last_updated_metric&.value_timestamp&.year
    end

    def last_updated_month
      last_updated_metric&.value_timestamp&.month
    end

    def last_updated_metric
      @last_updated_metric ||= Metric.where(
        ownable: blog_post,
        name: Metric.names[:blog_visits],
        interval: Metric.intervals[:monthly]
      ).order(:value_timestamp).last
    end

    def blog_post
      @blog_post ||= BlogPost.find_by!(blog_id: blog_post_id)
    end

    def wordpress_service
      @wordpress_service ||= WordpressService.new
    end
  end
end
