module Builders
  module Distribution
    class PullRequests < BaseService
      def initialize(department_name:, from:, langs:)
        @department_name = department_name
        @from = from.to_i
        @langs = langs
      end

      def call
        mt = @langs.reject(&:blank?).empty? ? merge_times : merge_times_filtered_by_languages
        mt.each_with_object(hash_of_arrays) do |merge_time, hash|
          interval = Metrics::MergeTime::TimeIntervalResolver.call(merge_time.value_as_hours)
          hash[interval] << merge_time.pull_request.html_url
        end
      end

      def merge_times
        @merge_times ||= ::MergeTime.where(created_at: @from.weeks.ago..Time.zone.now)
                                    .joins(pull_request: { project: { language: :department } })
                                    .where(departments: { name: @department_name })
                                    .includes(:pull_request)
      end

      def merge_times_filtered_by_languages
        merge_times.where(languages: { name: @langs })
      end

      def hash_of_arrays
        Hash.new { |hash, key| hash[key] = [] }
      end
    end
  end
end
