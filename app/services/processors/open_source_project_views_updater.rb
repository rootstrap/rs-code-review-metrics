module Processors
  class OpenSourceProjectViewsUpdater < BaseService
    def call
      Project.open_source.each do |project|
        views_to_update_for(project).each do |project_views_payload|
          update_views_metric_for_project(
            project,
            project_views_payload['timestamp'],
            project_views_payload['uniques']
          )
        end
      end
    end

    private

    def views_to_update_for(project)
      last_updated_timestamp = last_updated_timestamp_for(project)

      views_for_project(project)['views'].select do |views_payload|
        last_updated_timestamp <= views_payload['timestamp']
      end
    end

    def last_updated_timestamp_for(project)
      Metric.where(
        name: Metric.names[:open_source_visits],
        interval: Metric.intervals[:daily],
        ownable: project
      ).maximum(:value_timestamp) || Time.zone.at(0)
    end

    def views_for_project(project)
      GithubRepositoryClient.new(project.name).repository_views
    end

    def update_views_metric_for_project(project, timestamp, views)
      metric = Metric.find_or_initialize_by(
        ownable: project,
        name: Metric.names[:open_source_visits],
        interval: Metric.intervals[:daily],
        value_timestamp: timestamp
      )
      metric.value = views
      metric.save!
    end
  end
end
