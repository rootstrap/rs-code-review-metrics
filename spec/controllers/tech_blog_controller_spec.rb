require 'rails_helper'

describe TechBlogController, type: :request do
  describe '#index' do
    let(:technology) { create(:technology) }
    let!(:blog_post) { create(:blog_post, published_at: Time.zone.now, technology: technology) }
    let!(:previous_month_visits) do
      create(
        :metric,
        name: Metric.names[:blog_visits],
        interval: Metric.intervals[:monthly],
        ownable: technology,
        value: 125,
        value_timestamp: Time.zone.now.last_month.last_month.end_of_month
      )
    end
    let!(:last_month_visits) do
      create(
        :metric,
        name: Metric.names[:blog_visits],
        interval: Metric.intervals[:monthly],
        ownable: technology,
        value: 100,
        value_timestamp: Time.zone.now.last_month.end_of_month
      )
    end
    let!(:this_month_visits) do
      create(
        :metric,
        name: Metric.names[:blog_visits],
        interval: Metric.intervals[:monthly],
        ownable: technology,
        value: 110,
        value_timestamp: Time.zone.now.end_of_month
      )
    end
    let(:this_year_visits) do
      previous_month_visits.value + last_month_visits.value + this_month_visits.value
    end

    describe 'chart summaries' do
      it 'renders this month visits' do
        get tech_blog_url

        expect(response.body).to include "#{this_month_visits.value.to_i} visits this month"
      end

      it 'renders this year visits' do
        get tech_blog_url

        expect(response.body).to include "#{this_year_visits.to_i} visits this year"
      end

      it 'renders this month new blog posts count' do
        get tech_blog_url

        expect(response.body).to include '1 new posts this month'
      end

      it 'renders this year new blog posts count' do
        get tech_blog_url

        expect(response.body).to include '1 new posts this year'
      end

      it 'renders this month visits growth' do
        get tech_blog_url

        expect(response.body).to include '10.0% growth this month'
      end

      it 'renders last month visits growth' do
        get tech_blog_url

        expect(response.body).to include '-20.0% growth last month'
      end
    end
  end
end
