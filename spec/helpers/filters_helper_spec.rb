require 'rails_helper'

RSpec.describe FiltersHelper, type: :helper do
  let(:size_of_models_to_create) { 3 }
  let(:no_params) { {} }

  describe '.department_filter?' do
    let(:mobile) { { department_name: 'mobile' } }

    it 'if a department filter is present returns true' do
      allow(helper).to receive(:params).and_return(mobile)
      expect(helper.department_filter?).to be true
    end

    it 'if no department filter is present returns false' do
      allow(helper).to receive(:params).and_return(no_params)
      expect(helper.department_filter?).to be false
    end
  end

  describe '.department_name_filter' do
    let(:mobile) { { department_name: 'mobile' } }

    it 'if a department filter is present returns it' do
      allow(helper).to receive(:params).and_return(mobile)
      expect(helper.department_name_filter).to eq('mobile')
    end

    it 'if no department filter is present returns nil' do
      allow(helper).to receive(:params).and_return(no_params)
      expect(helper.department_name_filter).to be_nil
    end
  end

  describe '.filter_url_query' do
    let(:params) do
      {
        metric: { period: 'daily' },
        project_name: 'rs-metrics'
      }
    end

    it 'returns the url query with the current filter' do
      allow(helper).to receive(:params).and_return(params)
      expect(helper.filter_url_query).to eq(params)
    end
  end
end
