module Processors
  class ReviewTurnaround < Processors::Base
    ENTITIES = %w[UserProject Project Department Language].freeze

    private

    def process
      ENTITIES.each do |entity|
        Metrics::ReviewTurnaround.const_get("Per#{entity}").call
      end
    end
  end
end
