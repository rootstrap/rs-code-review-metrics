module Builders
  module Chartkick
    module RepositoryDistributionDataMetrics
      class PullRequestSize
        def retrieve_records(entity_id:, time_range:)
          ::Events::PullRequest
            .where(repository_id: entity_id)
            .where(opened_at: time_range)
            .where.not(size: nil)
            .where.not(owner: User.ignored_users)
        end

        def resolve_interval(entity)
          Metrics::IntervalResolver::PrSize.call(entity.size)
        end

        def value_for_average(entity)
          entity.size
        end
      end
    end
  end
end
