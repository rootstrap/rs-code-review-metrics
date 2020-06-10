module Builders
  class MetricsBase < BaseService
    def initialize(project_id, period_metric_query)
      @project_id = project_id
      @period_metric_query = period_metric_query
    end

    def call
      build
    end
  end
end
