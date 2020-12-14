module Builders
  module Chartkick
    class Base < BaseService
      def initialize(entity_id, query)
        @entity_id = entity_id
        @query = query
      end

      private

      def build_data(metrics)
        metrics.inject({}) do |hash, metric|
          hash.merge!(
            metric.value_timestamp.strftime('%Y-%m-%d').to_s => metric.value_as_hours
          )
        end
      end

      def build_distribution_data(entities)
        entities_by_interval = entities.each_with_object(Hash.new(0)) do |entity, hash|
          interval = resolve_interval(entity)
          hash[interval] += 1
        end
        entities_by_interval.sort_by { |key, _| key.slice(/[0-9]*[+-]/).to_i }
      end

      def build_success_rate(entities)
        intervals = build_distribution_data(entities)
        total = intervals.map { |interval| interval[1] }
                         .reduce(0) { |sum, num| sum + num }
        return if total.zero?

        successful = intervals
                     .select { |tuple| %w[1-12 12-24].include?(tuple[0]) }
                     .reduce(0) { |sum, tuple| sum + tuple[1] }
        rate = (successful * 100) / total
        { rate: rate, successful: successful, total: total }
      end
    end
  end
end
