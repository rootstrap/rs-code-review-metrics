module Builders
  module Chartkick
    class PlannedToDoneAverageData < Builders::Chartkick::ProductData
      def build_data(metrics)
        @count = 0
        @values = values(metrics)

        return if @values.empty?

        percentage = (@values.values.inject(:+) * 100)
        average = percentage.round / @count if @count.positive?

        { average: average }
      end

      def values(metrics)
        metrics.inject({}) do |hash, metric|
          sprints_values = sprints_average(metric.value[:planned_to_done_values])
          rates = sprints_values['rate']
          @count += sprints_values['count']

          hash.merge!(metric.value_timestamp.strftime('%Y-%m-%d').to_s => rates)
        end
      end

      def sprints_average(sprints)
        sprints.each_with_object(Hash.new(0)) do |sprint, result|
          committed = sprint[:committed]
          result['rate'] += (sprint[:completed] / committed.to_f).round(2) if committed.positive?
          result['count'] += 1
        end
      end
    end
  end
end
