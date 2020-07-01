module Processors
  class OpenSourceMetricsUpdater < BaseService
    def call
      update_open_source_visits
    end

    private

    def update_open_source_visits
      OpenSourceProjectViewsUpdater.call
    end
  end
end
