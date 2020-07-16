module Builders
  module MetricChart
    module OpenSource
      class Base < Builders::MetricChart::Base
        def initialize(periods = 24)
          Groupdate.week_start = :monday
          super(periods)
        end

        private

        def entities
          Language.where.not(name: 'unassigned')
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

        def metric_interval
          :weekly
        end

        def chart_date_format
          '%Y-%m-%d'
        end

        def grouping_period
          :week
        end
      end
    end
  end
end
