require 'rails_helper'

RSpec.describe Metrics::MergeTime::PerLanguage do
  describe '.call' do
    before { travel_to(Time.zone.today.end_of_day) }

    let(:ruby_lang)  { Language.find_by(name: 'ruby')  }
    let(:react_lang) { Language.find_by(name: 'react') }
    let!(:first_project)  { create(:project, language: ruby_lang)  }
    let!(:second_project) { create(:project, language: react_lang) }

    context 'when there are two merged pull request with different languages' do
      let!(:first_project_pull_request) do
        create(:pull_request,
               project: first_project,
               opened_at: Time.zone.today.beginning_of_day)
      end

      let!(:second_project_pull_request) do
        create(:pull_request,
               project: second_project,
               opened_at: Time.zone.today.beginning_of_day)
      end

      before do
        first_project_pull_request.update!(merged_at: Time.zone.today.beginning_of_day + 1.hour)
        second_project_pull_request.update!(merged_at: Time.zone.today.beginning_of_day + 2.hours)
      end

      it 'creates two metrics' do
        expect { described_class.call }.to change { Metric.count }.by(2)
      end

      it 'saves one hour as value for merge time metric in backend language' do
        described_class.call
        expect(Metric.first.value.seconds).to eq(1.hour)
      end

      it 'saves two hours as value for merge time metric in frontend language' do
        described_class.call
        expect(Metric.second.value.seconds).to eq(2.hours)
      end
    end

    context 'when there are two project metrics per language' do
      let!(:first_pull_first_project) do
        create(:pull_request,
               project: first_project,
               opened_at: Time.zone.today.beginning_of_day)
      end

      let!(:second_pull_first_project) do
        create(:pull_request,
               project: first_project,
               opened_at: Time.zone.today.beginning_of_day)
      end

      let!(:first_pull_second_project) do
        create(:pull_request,
               project: second_project,
               opened_at: Time.zone.today.beginning_of_day)
      end

      let!(:second_pull_second_project) do
        create(:pull_request,
               project: second_project,
               opened_at: Time.zone.today.beginning_of_day)
      end

      before do
        first_pull_first_project.update!(merged_at: Time.zone.today.beginning_of_day + 30.minutes)
        second_pull_first_project.update!(merged_at: Time.zone.today.beginning_of_day + 50.minutes)
        first_pull_second_project.update!(merged_at: Time.zone.today.beginning_of_day + 10.minutes)
        second_pull_second_project.update!(merged_at: Time.zone.today.beginning_of_day + 2.hours)
      end

      it 'creates two metrics' do
        expect { described_class.call }.to change { Metric.count }.by(2)
      end

      it 'saves forty minutes as average for merge time backend department' do
        described_class.call
        expect(Metric.first.value.seconds).to eq(40.minutes)
      end

      it 'saves sixty five minutes as average for merge time backend department' do
        described_class.call
        expect(Metric.second.value.seconds).to eq(65.minutes)
      end
    end
  end
end
