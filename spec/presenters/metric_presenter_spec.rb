require 'rails_helper'

RSpec.describe RepositoryMetricPresenter do
  let(:metric) do
    {
      per_repository: [ { name: 'forecast', data: {} }],
      per_users_repository: [{ name: 'horacio', data:{ "2022-10-24":3.0 }},
                              { name:'hvilloria', data:{"2022-10-24":5.0 } },
                             { name: 'sandro', data:{ "2022-10-24":14.0 }}],
      per_repository_distribution:[{ name: 'forecast', data:[], success_rate: nil }]
    }
  end
  let(:metric_def) { build(:metric_definition) }

  subject { described_class.new(metric, metric_def) }

  describe 'metric filters' do
    describe '#per_repository_has_data_to_display?' do
      it 'should return false' do
        expect(subject.per_repository_has_data_to_display?).to be(false)
      end
    end

    describe '#per_users_repository_has_data_to_display?' do
      it 'should return true' do
        expect(subject.per_users_repository_has_data_to_display?).to be(true)
      end
    end

    describe '#per_repository_distribution_has_data_to_display?' do
      it 'should return false' do
        expect(subject.per_repository_distribution_has_data_to_display?).to be(false)
      end
    end
  end

end