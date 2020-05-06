module Processors
  class ReviewTurnaround < BaseService
    ENTITIES = ['UserProject'].freeze

    def initialize(interval)
      @interval = interval
    end

    def call
      process
    end

    private

    def process
      ENTITIES.each do |entity|
        "Metrics::#{@interval.classify}::ReviewTurnaround::Per#{entity.classify}"
          .constantize
          .call
      end
    end
  end
end
