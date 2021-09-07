module Builders
  module Distribution
    module PullRequests
      class TimeToSecondReview < BaseService
        def initialize(department_name:, from:, languages:)
          @department_name = department_name
          @from = from.to_i
          @languages = languages
        end

        def call
          completed_rt_records.each_with_object(hash_of_arrays) { |completed_rt, hash|
            interval = Metrics::IntervalResolver::Time.call(completed_rt.value_as_hours)
            hash[interval] << completed_rt.review_request.pull_request.html_url
          }.sort.to_h
        end

        private

        def completed_rt_records
          @languages.reject(&:blank?).empty? ? completed_rt : completed_rt_filtered_by_languages
        end

        def completed_rt
          period = @from.weeks.ago..Time.zone.now
          @completed_rt ||= begin
            ::CompletedReviewTurnaround.where(created_at: period)
                                       .joins(review_request:
                                        { pull_request: { repository: { language: :department } } })
                                       .where(departments: { name: @department_name })
                                       .where.not(events_pull_requests: { html_url: nil })
                                       .includes(review_request: :pull_request)
          end
        end

        def completed_rt_filtered_by_languages
          completed_rt.where(languages: { name: @languages })
        end

        def hash_of_arrays
          Hash.new { |hash, key| hash[key] = [] }
        end
      end
    end
  end
end
