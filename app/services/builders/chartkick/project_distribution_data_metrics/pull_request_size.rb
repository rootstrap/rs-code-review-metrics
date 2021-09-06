module Builders
  module Chartkick
    module ProjectDistributionDataMetrics
      class PullRequestSize
        def retrieve_records(entity_id:, time_range:)
          ::Events::PullRequest
            .where(repository_id: entity_id)
            .where(opened_at: time_range)
            .where.not(size: nil)
        end

        def resolve_interval(entity)
          Metrics::IntervalResolver::PrSize.call(entity.size)
        end
      end
    end
  end
end
