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
    Builders::BlogMetricChart::TechnologyVisits.call
  end

  def year_to_date_visits
    Builders::ChartSummary::YearToDateBlogVisits.call.to_i
  end

  def month_to_date_visits
    totals_for(@visits_per_technology)[:data][current_month_key].to_i
  end

  def technology_blog_post_count
    Builders::BlogMetricChart::TechnologyBlogPostCount.call
  end

  def year_to_date_new_blog_posts
    Builders::ChartSummary::YearToDateNewBlogPosts.call
  end

  def month_to_date_new_blog_posts
    Builders::ChartSummary::MonthToDateNewBlogPosts.call
  end

  def visits_growth_mom
    Builders::BlogMetricChart::TechnologyVisitsGrowthMom.call
  end

  def this_month_visits_growth
    totals_for(@visits_growth_mom)[:data][current_month_key].round(2)
  end

  def last_month_visits_growth
    totals_for(@visits_growth_mom)[:data][last_month_key].round(2)
  end

  def totals_for(metric_datasets)
    metric_datasets.find { |metric_dataset| metric_dataset[:name] == 'Totals' }
  end

  def current_month_key
    Time.zone.now.strftime(monthly_key_format)
  end

  def last_month_key
    Time.zone.now.last_month.strftime(monthly_key_format)
  end

  def monthly_key_format
    '%B %Y'
  end
end
