module Processors
  class OpenSourceMetricsUpdater < BaseService
    def call
      update_open_source_visits
    end

    private

    def update_open_source_visits
      Project.open_source.each do |project|
        OpenSourceProjectViewsUpdater.call(project)
      end
    end
  end
end
