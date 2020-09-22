require 'rails_helper'

RSpec.describe Metrics::MergeTime::PerDepartment do
  describe '.call' do
    before { travel_to(Time.zone.today.end_of_day) }

    let(:backend_department) { ruby_lang.department }
    let(:frontend_department) { react_lang.department }
    let(:ruby_lang)  { Language.find_by(name: 'ruby')  }
    let(:react_lang) { Language.find_by(name: 'react') }
    let!(:first_project)  { create(:project, language: ruby_lang)  }
    let!(:second_project) { create(:project, language: react_lang) }
    let(:beginning_of_day) { Time.zone.today.beginning_of_day }

    context 'when there are two merged pull request from different departments' do
      let!(:first_project_pull_request) do
        create(:pull_request,
               project: first_project,
               opened_at: beginning_of_day)
      end

      let!(:second_project_pull_request) do
        create(:pull_request,
               project: second_project,
               opened_at: beginning_of_day)
      end

      before do
        first_project_pull_request.update!(merged_at: beginning_of_day + 1.hour)
        second_project_pull_request.update!(merged_at: beginning_of_day + 2.hours)
      end

      it 'creates two metrics' do
        expect { described_class.call }.to change { Metric.count }.by(2)
      end

      it 'saves one hour as value for merge time metric in backend department' do
        described_class.call
        expect(backend_department.metrics.first.value.seconds).to eq(1.hour)
      end

      it 'saves two hours as value for merge time metric in frontend department' do
        described_class.call
        expect(frontend_department.metrics.first.value.seconds).to eq(2.hours)
      end
    end

    context 'when there are two project metrics per department' do
      let!(:first_pull_first_project) do
        create(:pull_request,
               project: first_project,
               opened_at: beginning_of_day)
      end

      let!(:second_pull_first_project) do
        create(:pull_request,
               project: first_project,
               opened_at: beginning_of_day)
      end

      let!(:first_pull_second_project) do
        create(:pull_request,
               project: second_project,
               opened_at: beginning_of_day)
      end

      let!(:second_pull_second_project) do
        create(:pull_request,
               project: second_project,
               opened_at: beginning_of_day)
      end

      before do
        first_pull_first_project.update!(merged_at: beginning_of_day + 30.minutes)
        second_pull_first_project.update!(merged_at: beginning_of_day + 50.minutes)
        first_pull_second_project.update!(merged_at: beginning_of_day + 10.minutes)
        second_pull_second_project.update!(merged_at: beginning_of_day + 2.hours)
      end

      it 'creates two metrics' do
        expect { described_class.call }.to change { Metric.count }.by(2)
      end

      it 'saves forty minutes as average for merge time backend department' do
        described_class.call
        expect(backend_department.metrics.first.value.seconds).to eq(40.minutes)
      end

      it 'saves sixty five minutes as average for merge time frontend department' do
        described_class.call
        expect(frontend_department.metrics.first.value.seconds).to eq(65.minutes)
      end
    end
  end
end
