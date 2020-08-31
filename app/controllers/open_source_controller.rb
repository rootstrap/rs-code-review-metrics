class OpenSourceController < ApplicationController
  layout 'sidebar_metrics'

  def index
    @visits_per_language = visits_per_language
    @projects_per_language = projects_per_language
    @total_projects = @projects_per_language.values.sum
  end

  private

  def visits_per_language
    Builders::MetricChart::OpenSource::LanguageVisits.call
  end

  def projects_per_language
    Builders::ChartSummary::LifetimeOpenSourceProjectCount.call
  end
end
