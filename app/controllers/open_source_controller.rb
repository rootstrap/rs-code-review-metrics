class OpenSourceController < ApplicationController
  def index
    @visits_per_language = visits_per_language
  end

  private

  def visits_per_language
    Builders::MetricChart::OpenSource::LanguageVisits.call
  end
end
