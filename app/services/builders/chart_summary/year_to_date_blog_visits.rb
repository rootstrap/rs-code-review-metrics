module Builders
  module ChartSummary
    class YearToDateBlogVisits < BaseService
      def call
        Metric
          .where(name: Metric.names[:blog_visits], ownable_type: Technology.to_s)
          .where('value_timestamp > ?', Time.zone.now.beginning_of_year)
          .sum(:value)
      end
    end
  end
end
