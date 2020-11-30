module Processors
  class OpenSourceProjectViewsUpdater < BaseService
    def initialize(project)
      @project = project
    end

    def call
      views_to_update.each do |project_views_payload|
        update_views_metric(
          project_views_payload['timestamp'],
          project_views_payload['uniques']
        )
      end
    rescue Faraday::Error => exception
      track_request_error(exception)
    end

    private

    attr_reader :project

    def views_to_update
      views_payload['views'].select do |views_payload|
        last_updated_timestamp <= views_payload['timestamp']
      end
    end

    def last_updated_timestamp
      Metric.where(
        name: Metric.names[:open_source_visits],
        interval: Metric.intervals[:weekly],
        ownable: project
      ).maximum(:value_timestamp) || Time.zone.at(0)
    end

    def views_payload
      GithubClient::Repository.new(project).views
    end

    def update_views_metric(timestamp, views)
      metric = Metric.find_or_initialize_by(
        ownable: project,
        name: Metric.names[:open_source_visits],
        interval: Metric.intervals[:weekly],
        value_timestamp: timestamp
      )
      metric.value = views
      metric.save!
    end
  end
end
