class TechBlogController < ApplicationController
  def index
    @visits_per_technology = visits_per_technology
  end

  private

  def visits_per_technology
    BlogMetricChartBuilder.new.technology_visits
  end
end
