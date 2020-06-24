require 'rails_helper'

describe Builders::ChartSummary::MonthToDateNewBlogPosts do
  describe '.call' do
    let!(:last_month_blog_post) do
      create(:blog_post, published_at: Time.zone.now.last_month)
    end
    let!(:this_month_blog_post) do
      create(:blog_post, published_at: Time.zone.now)
    end

    it 'returns the total number of new posts for the current month' do
      expect(described_class.call).to eq 1
    end
  end
end
