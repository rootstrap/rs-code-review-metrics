class OpenSourceController < ApplicationController
  layout 'sidebar_metrics'

  def index
    @visits_per_language = visits_per_language
    @repositories_per_language = repositories_per_language
    @total_repositories = @repositories_per_language.values.sum
  end

  private

  def visits_per_language
    Builders::MetricChart::OpenSource::LanguageVisits.call
  end

  def repositories_per_language
    Builders::ChartSummary::LifetimeOpenSourceRepositoryCount.call
  end
end
