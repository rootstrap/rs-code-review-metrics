module Builders
  module Chartkick
    class RepositoryData < Builders::Chartkick::Base
      def call
        repository = ::Repository.find(@entity_id)

        metrics = Metrics
                  .const_get(@query[:name].to_s.camelize)::PerRepository
                  .call(repository.id, @query[:value_timestamp])
        [{ name: repository.name, data: build_data(metrics) }]
      end
    end
  end
end
