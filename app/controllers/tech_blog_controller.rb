class TechBlogController < ApplicationController
  def index
    @visits_per_technology = visits_per_technology
    @year_to_date_visits = year_to_date_visits
    @month_to_date_visits = month_to_date_visits

    @blog_post_count_per_technology = technology_blog_post_count
    @year_to_date_new_blog_posts = year_to_date_new_blog_posts
    @month_to_date_new_blog_posts = month_to_date_new_blog_posts

    @visits_growth_mom = visits_growth_mom
    @this_month_visits_growth = this_month_visits_growth
    @last_month_visits_growth = last_month_visits_growth
  end

  private

  def visits_per_technology
    Builders::MetricChart::Blog::TechnologyVisits.call
  end

  def year_to_date_visits
    Builders::ChartSummary::YearToDateBlogVisits.call
  end

  def month_to_date_visits
    @visits_per_technology.totals_for(Time.zone.now).to_i
  end

  def technology_blog_post_count
    Builders::MetricChart::Blog::TechnologyBlogPostCount.call
  end

  def year_to_date_new_blog_posts
    Builders::ChartSummary::YearToDateNewBlogPosts.call
  end

  def month_to_date_new_blog_posts
    Builders::ChartSummary::MonthToDateNewBlogPosts.call
  end

  def visits_growth_mom
    Builders::MetricChart::Blog::TechnologyVisitsGrowthMom.call
  end

  def this_month_visits_growth
    @visits_growth_mom.totals_for(Time.zone.now).round(2)
  end

  def last_month_visits_growth
    @visits_growth_mom.totals_for(Time.zone.now.last_month).round(2)
  end
end
