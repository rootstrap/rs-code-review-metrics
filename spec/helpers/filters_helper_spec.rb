require 'rails_helper'

RSpec.describe FiltersHelper, type: :helper do
  describe '.filter_url_query' do
    let(:params) do
      {
        metric: { period: 'daily' },
        repository_name: 'rs-metrics'
      }
    end

    it 'returns the url query with the current filter' do
      allow(helper).to receive(:params).and_return(params)
      expect(helper.filter_url_query).to eq(params)
    end
  end
end
