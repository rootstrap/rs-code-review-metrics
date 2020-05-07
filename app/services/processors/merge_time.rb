module Processors
  class MergeTime < BaseService
    ENTITIES = ['UserProject'].freeze

    def call
      process
    end

    private

    def process
      ENTITIES.each do |entity|
        Metrics::MergeTime.const_get("Per#{entity}").call
      end
    end
  end
end
