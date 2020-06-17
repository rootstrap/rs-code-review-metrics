class TechBlogController < ApplicationController
  def index
    @visits_per_technology = visits_per_technology
    @visits_growth_mom = visits_growth_mom
    @blog_post_count_per_technology = technology_blog_post_count
  end

  private

  def visits_per_technology
    Builders::BlogMetricChart::TechnologyVisits.call
  end

  def visits_growth_mom
    Builders::BlogMetricChart::TechnologyVisitsGrowthMom.call
  end

  def technology_blog_post_count
    Builders::BlogMetricChart::TechnologyBlogPostCount.call
  end
end
