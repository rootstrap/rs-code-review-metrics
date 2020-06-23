module Processors
  class MergeTime < BaseService
    ENTITIES = %w[UserProject Project Department Language].freeze

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
