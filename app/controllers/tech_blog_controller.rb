class TechBlogController < ApplicationController
  def index
    @visits_per_technology = visits_per_technology
    @blog_post_count_per_technology = technology_blog_post_count
  end

  private

  def visits_per_technology
    BlogMetricChartBuilder.new.technology_visits
  end

  def technology_blog_post_count
    BlogMetricChartBuilder.new.technology_blog_post_count
  end
end
