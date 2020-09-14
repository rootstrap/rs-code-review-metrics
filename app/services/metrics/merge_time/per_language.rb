module Metrics
  module MergeTime
    class PerLanguage < Metrics::BaseDevelopmentMetrics
      private

      def process
        project_metrics_per_language.each do |language_id, merge_times_value|
          create_or_update_metric(language_id, Language.name, merge_time_interval,
                                  merge_times_value, :merge_time)
        end
      end

      def project_metrics_per_language
        Language.joins(projects: { pull_requests: :merge_time })
                .where(merge_times: { created_at: merge_time_interval })
                .group(:id)
                .pluck(:id, Arel.sql('AVG(merge_times.value)'))
      end

      def merge_time_interval
        @merge_time_interval ||= @interval || Time.zone.today.all_day
      end
    end
  end
end
