module Processors
  class OpenSourceMetricsUpdater < BaseService
    def call
      update_open_source_visits
    end

    private

    def update_open_source_visits
      Repository.open_source.each do |repository|
        OpenSourceRepositoryViewsUpdater.call(repository)
      end
    end
  end
end
