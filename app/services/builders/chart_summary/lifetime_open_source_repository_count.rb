module Builders
  module ChartSummary
    class LifetimeOpenSourceRepositoryCount < BaseService
      def call
        ::Repository.open_source.group(:language).count.transform_keys(&:name)
      end
    end
  end
end
