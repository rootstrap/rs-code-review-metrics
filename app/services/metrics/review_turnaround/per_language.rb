module Metrics
  module ReviewTurnaround
    class PerLanguage < Metrics::BaseDevelopmentMetrics
      private

      def process
        project_metrics_per_language.each do |language_id, amount, metrics_value|
          turnaround = calculate_average(metrics_value, amount)
          create_or_update_metric(language_id, Language.name, metric_interval,
                                  turnaround, :review_turnaround)
        end
      end

      def project_metrics_per_language
        Language.joins(projects: :metrics)
                .where(metrics: { name: :review_turnaround })
                .group(:id)
                .pluck(:id, Arel.sql('COUNT(*), SUM(metrics.value)'))
      end

      def calculate_average(metrics_value, amount)
        metrics_value / amount
      end

      def metric_interval
        @metric_interval ||= @interval || Time.zone.today.all_day
      end
    end
  end
end
