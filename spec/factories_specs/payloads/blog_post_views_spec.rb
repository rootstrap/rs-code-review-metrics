require 'rails_helper'

RSpec.describe 'blog_post_views_payload' do
  let(:total_2019) { 42 }
  let(:total_2020) { 32 }
  let(:years) do
    {
      '2019' => {
        'months' => {
          '9' => 10,
          '10' => 11,
          '11' => 12,
          '12' => 9
        }
      },
      '2020' => {
        'months' => {
          '1' => 4,
          '2' => 13,
          '3' => 7,
          '4' => 6,
          '5' => 2
        }
      }
    }
  end
  let(:payload) { create(:blog_post_views_payload, years: years) }

  describe 'yearly views' do
    it "are equal to the sum of that year's monthly views" do
      expect(payload['years']['2019']['total']).to eq total_2019
      expect(payload['years']['2020']['total']).to eq total_2020
    end
  end

  describe 'lifetime views' do
    it 'are equal to the sum of all yearly views' do
      expect(payload['views']).to eq total_2019 + total_2020
    end
  end
end
