module Builders
  module MetricChart
    module OpenSource
      class Base < Builders::MetricChart::Base
        def entity_type
          Language
        end

        def entity_name(language)
          language.name.titlecase
        end

        def entity_metrics(language)
          language.projects_metrics
        end

        def metric_ownable_type
          ::Project
        end
      end
    end
  end
end
