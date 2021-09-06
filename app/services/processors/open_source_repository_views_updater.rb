module Processors
  class OpenSourceRepositoryViewsUpdater < BaseService
    def initialize(repository)
      @repository = repository
    end

    def call
      views_to_update.each do |repository_views_payload|
        update_views_metric(
          repository_views_payload['timestamp'],
          repository_views_payload['uniques']
        )
      end
    rescue Faraday::Error => exception
      track_request_error(exception)
    end

    private

    attr_reader :repository

    def views_to_update
      views_payload['views'].select do |views_payload|
        last_updated_timestamp <= views_payload['timestamp']
      end
    end

    def last_updated_timestamp
      Metric.where(
        name: Metric.names[:open_source_visits],
        interval: Metric.intervals[:weekly],
        ownable: repository
      ).maximum(:value_timestamp) || Time.zone.at(0)
    end

    def views_payload
      GithubClient::Repository.new(repository).views
    end

    def update_views_metric(timestamp, views)
      metric = Metric.find_or_initialize_by(
        ownable: repository,
        name: Metric.names[:open_source_visits],
        interval: Metric.intervals[:weekly],
        value_timestamp: timestamp
      )
      metric.value = views
      metric.save!
    end
  end
end
