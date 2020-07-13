module Builders
  module MetricChart
    module Blog
      class Base < Builders::MetricChart::Base
        def entity_type
          Technology
        end

        def entity_name(technology)
          technology.name.titlecase
        end

        def entity_metrics(technology)
          technology.metrics
        end

        def metric_ownable_type
          entity_type
        end
      end
    end
  end
end
