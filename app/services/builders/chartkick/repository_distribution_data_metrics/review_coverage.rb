module Builders
  module Chartkick
    module RepositoryDistributionDataMetrics
      class ReviewCoverage
        def retrieve_records(entity_id:, time_range:, base_branch: nil)
          query = ::ReviewCoverage
                  .joins(pull_request: :repository)
                  .where(repositories: { id: entity_id })
                  .where(events_pull_requests: { merged_at: time_range })
                  .where.not(events_pull_requests: { owner: User.ignored_users })

          if base_branch.present?
            query = query.where(events_pull_requests: { base_branch: base_branch })
          end
          query
        end

        def resolve_interval(entity)
          Metrics::IntervalResolver::Percentage.call(entity.coverage_percentage * 100)
        end

        def value_for_average(entity)
          entity.coverage_percentage * 100
        end

        def zero_coverage_percentage(records)
          return 0 if records.empty?

          zero_coverage_count = records.with_zero_coverage.count
          total_count = records.count

          ((zero_coverage_count.to_f / total_count) * 100).round
        end
      end
    end
  end
end
