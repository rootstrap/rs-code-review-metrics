require 'rails_helper'

RSpec.describe Metrics::MergeTime::PerProject do
  describe '.call' do
    let(:project) { create(:project) }
    let(:current_time) { Time.zone.now }
    let(:beginning_of_day) { Time.zone.today.beginning_of_day }

    before { travel_to(Time.zone.today.end_of_day) }

    context 'when processing a collection containing no pull request events' do
      it 'does not create any metric' do
        expect { described_class.call }.not_to change { Metric.count }
      end
    end

    context 'when a project has pull requests' do
      let!(:first_pull_request) do
        create(:pull_request,
               state: :open,
               project_id: project.id,
               opened_at: beginning_of_day)
      end

      let!(:second_pull_request) do
        create(:pull_request,
               state: :open,
               project_id: project.id,
               opened_at: beginning_of_day)
      end

      before do
        first_pull_request.update!(merged_at: beginning_of_day + 20.minutes)
        second_pull_request.update!(merged_at: beginning_of_day + 40.minutes)
      end

      it 'generates a metric with the average value of each pull request merge times' do
        described_class.call
        expect(Metric.first.value.seconds).to eq(30.minutes)
      end

      it 'generates only that metric' do
        expect { described_class.call }.to change { Metric.count }.from(0).to(1)
      end

      context 'having some pull requests still open' do
        let!(:open_pull_request) do
          create(:pull_request,
                 state: :open,
                 project_id: project.id,
                 opened_at: beginning_of_day)
        end

        it 'does not count them' do
          described_class.call
          expect(Metric.first.value.seconds).to eq(30.minutes)
        end
      end

      context 'having some pull requests merged another day' do
        let!(:old_pull_request) do
          create(:pull_request,
                 state: :open,
                 project_id: project.id,
                 opened_at: beginning_of_day.last_week)
        end

        before do
          old_pull_request.update!(merged_at: beginning_of_day.last_week + 10.minutes)
        end

        it 'does not count them' do
          described_class.call
          expect(Metric.first.value.seconds).to eq(30.minutes)
        end
      end

      context 'when there are more projects with pull requests' do
        let(:second_project) { create(:project) }

        let!(:third_pull_request) do
          create(:pull_request,
                 state: :open,
                 project_id: second_project.id,
                 opened_at: beginning_of_day)
        end

        let!(:fourth_pull_request) do
          create(:pull_request,
                 state: :open,
                 project_id: second_project.id,
                 opened_at: beginning_of_day)
        end

        before do
          third_pull_request.update!(merged_at: beginning_of_day + 30.minutes)
          fourth_pull_request.update!(merged_at: beginning_of_day + 50.minutes)
        end

        it 'creates two metrics' do
          expect { described_class.call }.to change { Metric.count }.by(2)
        end

        it 'correctly generates the metric for the first project' do
          described_class.call
          expect(project.metrics.first.value.seconds).to eq(30.minutes)
        end

        it 'correctly generates the metric for the second project' do
          described_class.call
          expect(second_project.metrics.first.value.seconds).to eq(40.minutes)
        end
      end
    end
  end
end
