module Builders
  module MetricChart
    module Blog
      class Base < Builders::MetricChart::Base
        private

        def entities
          Technology.all
        end

        def entity_name(technology)
          technology.name.titlecase
        end

        def entity_metrics(technology)
          technology.metrics
        end

        def metric_totals_ownable_type
          BlogPost
        end

        def metric_interval
          :monthly
        end

        def chart_date_format
          '%B %Y'
        end

        def grouping_period
          :month
        end
      end
    end
  end
end
