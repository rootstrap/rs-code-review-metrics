module Builders
  module Distribution
    module PullRequests
      class TimeToMerge < BaseService
        def initialize(department_name:, from:, languages:)
          @department_name = department_name
          @from = from.to_i
          @languages = languages
        end

        def call
          merge_time_records.each_with_object(hash_of_arrays) { |merge_time, hash|
            interval = Metrics::IntervalResolver::Time.call(merge_time.value_as_hours)
            hash[interval] << merge_time.pull_request.html_url
          }.sort.to_h
        end

        private

        def merge_times
          @merge_times ||= ::MergeTime.where(created_at: @from.weeks.ago..Time.zone.now)
                                      .joins(pull_request: { project: { language: :department } })
                                      .where(departments: { name: @department_name })
                                      .where.not(events_pull_requests: { html_url: nil })
                                      .includes(:pull_request)
        end

        def merge_times_filtered_by_languages
          merge_times.where(languages: { name: @languages })
        end

        def merge_time_records
          @languages.reject(&:blank?).empty? ? merge_times : merge_times_filtered_by_languages
        end

        def hash_of_arrays
          Hash.new { |hash, key| hash[key] = [] }
        end
      end
    end
  end
end
