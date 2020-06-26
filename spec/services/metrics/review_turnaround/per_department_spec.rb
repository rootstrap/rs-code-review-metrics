require 'rails_helper'

RSpec.describe Metrics::ReviewTurnaround::PerDepartment do
  describe '.call' do
    before { travel_to(Time.zone.today.beginning_of_day) }

    let(:ruby_lang)  { Language.find_by(name: 'ruby')  }
    let(:react_lang) { Language.find_by(name: 'react') }
    let!(:first_project)  { create(:project, language: ruby_lang)  }
    let!(:second_project) { create(:project, language: react_lang) }

    context 'when there are two project metrics from different departments' do
      before do
        create(:metric, value: 30.minutes, ownable: first_project)
        create(:metric, value: 25.minutes, ownable: second_project)
      end

      it 'creates two metrics' do
        expect { described_class.call }.to change { Metric.count }.from(2).to(4)
      end

      it 'should has value of 30 minutes' do
        described_class.call
        expect(Metric.third.value.seconds).to eq(30.minutes)
      end
    end

    context 'when there are two project metrics per department' do
      before do
        create(:metric, value: 15.minutes, ownable: first_project)
        create(:metric, value: 25.minutes, ownable: first_project)
        create(:metric, value: 45.minutes, ownable: second_project)
        create(:metric, value: 15.minutes, ownable: second_project)
      end

      it 'creates two metrics' do
        expect { described_class.call }.to change { Metric.count }.from(4).to(6)
      end

      it 'should has value of 20 minutes' do
        described_class.call
        expect(Metric.fifth.value.seconds).to eq(20.minutes)
      end
    end
  end
end
