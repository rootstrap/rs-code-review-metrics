module Builders
  module BlogMetricChart
    class Base < BaseService
      def call
        formatted_metrics = Technology.all.map do |technology|
          {
            name: technology.name.titlecase,
            data: data_for(technology.metrics)
          }
        end

        formatted_metrics << totals_hash
      end

      private

      def data_for(technology_metrics)
        technology_metrics.where(name: metric_name)
                          .group_by_month(:value_timestamp, last: 13, format: '%B %Y')
                          .sum(:value)
      end

      def totals_hash
        {
          name: 'Totals',
          data: data_for(Metric.where(ownable_type: Technology.to_s))
        }
      end
    end
  end
end
