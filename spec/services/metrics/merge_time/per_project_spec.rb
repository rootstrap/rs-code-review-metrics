require 'rails_helper'

RSpec.describe Metrics::MergeTime::PerProject do
  describe '.call' do
    let(:project) { create(:project) }
    let(:current_time) { Time.zone.now }

    before { travel_to(Time.zone.today.beginning_of_day) }

    context 'when processing a collection containing no pull request events' do
      it 'does not create a metric' do
        expect { described_class.call }.not_to change { Metric.count }
      end
    end

    context 'Generating metrics values' do
      context 'when a project has 30 minutes of merge time' do
        let!(:first_pull_request) do
          create(:pull_request,
                 state: :open,
                 project_id: project.id,
                 opened_at: current_time,
                 merged_at: 30.minutes.from_now(current_time))
        end
        let!(:second_pull_request) do
          create(:pull_request,
                 state: :open,
                 project_id: project.id,
                 opened_at: current_time,
                 merged_at: 30.minutes.from_now(current_time))
        end

        it 'generates a metric with value expressed as decimal equal to 30 minutes' do
          described_class.call
          expect(Metric.first.value.seconds).to eq(30.minutes)
        end

        it 'generates only that metric' do
          expect { described_class.call }.to change { Metric.count }.from(0).to(1)
        end
      end

      context 'when there are multiple projects with pull requests' do
        let(:second_project) { create(:project) }
        let!(:first_pull_request) do
          create(:pull_request,
                 state: :open,
                 project_id: project.id,
                 opened_at: 30.minutes.from_now(current_time),
                 merged_at: current_time)
        end
        let!(:second_pull_request) do
          create(:pull_request,
                 state: :open,
                 project_id: second_project.id,
                 opened_at: 30.minutes.from_now(current_time),
                 merged_at: current_time)
        end
        let!(:third_pull_request) do
          create(:pull_request,
                 state: :open,
                 project_id: project.id,
                 opened_at: 30.minutes.from_now(current_time),
                 merged_at: current_time)
        end
        let!(:fourth_pull_request) do
          create(:pull_request,
                 state: :open,
                 project_id: second_project.id,
                 opened_at: 30.minutes.from_now(current_time),
                 merged_at: current_time)
        end

        it 'creates two metrics' do
          expect { described_class.call }.to change { Metric.count }.from(0).to(2)
        end
      end
    end
  end
end
