module Builders
  module Chartkick
    class UsersRepositoryData < Builders::Chartkick::Base
      def call
        metrics.group_by(&:ownable_id).map do |user_repository_metrics|
          user_repository = UsersRepository.find(user_repository_metrics.first)
          { name: user_repository.user_name, data: build_data(user_repository_metrics.second) }
        end
      end

      private

      def metrics
        Metrics
          .const_get(@query[:name].to_s.camelize)::PerUserRepository
          .call(users_ids, @query[:value_timestamp])
      end

      def users_ids
        UsersRepository.where(repository_id: @entity_id).pluck(:user_id)
      end
    end
  end
end
