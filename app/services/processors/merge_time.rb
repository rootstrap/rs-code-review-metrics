module Processors
  class MergeTime < Processors::Base
    ENTITIES = %w[UserProject Project Department Language].freeze

    private

    def process
      ENTITIES.each do |entity|
        Metrics::MergeTime.const_get("Per#{entity}").call
      end
    end
  end
end
