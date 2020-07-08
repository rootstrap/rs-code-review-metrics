module Builders
  module MetricChart
    module OpenSource
      class LanguageVisits < Builders::MetricChart::OpenSource::Base
        def metric_name
          Metric.names[:open_source_visits]
        end
      end
    end
  end
end
