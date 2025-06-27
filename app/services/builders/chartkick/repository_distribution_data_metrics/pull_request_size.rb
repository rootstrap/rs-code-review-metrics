module Builders
  module Chartkick
    module RepositoryDistributionDataMetrics
      class PullRequestSize
        def retrieve_records(entity_id:, time_range:, base_branch: nil)
          query = ::Events::PullRequest
                  .where(repository_id: entity_id)
                  .where(opened_at: time_range)
                  .where.not(size: nil)
                  .where.not(owner: User.ignored_users)

          query = query.where(base_branch: base_branch) if base_branch.present?
          query
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
