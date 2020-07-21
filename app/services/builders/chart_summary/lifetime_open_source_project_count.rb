module Builders
  module ChartSummary
    class LifetimeOpenSourceProjectCount < BaseService
      def call
        ::Project.open_source.group(:language).count.transform_keys(&:name)
      end
    end
  end
end
