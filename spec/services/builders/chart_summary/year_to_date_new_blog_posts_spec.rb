require 'rails_helper'

describe Builders::ChartSummary::YearToDateNewBlogPosts do
  describe '.call' do
    let!(:last_year_blog_post) do
      create(:blog_post, published_at: Time.zone.now.last_year)
    end
    let!(:this_year_blog_post) do
      create(:blog_post, published_at: Time.zone.now)
    end

    it 'returns the total number of new posts for the current year' do
      expect(described_class.call).to eq 1
    end
  end
end
