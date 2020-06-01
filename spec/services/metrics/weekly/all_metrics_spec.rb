require 'rails_helper'

RSpec.describe Metrics::Weekly::AllMetrics do
  describe '#call' do
    let(:user_project) { create(:users_project) }

    before do
      travel_to Time.zone.parse('2020-05-07')
    end

    let!(:current_time) { Time.zone.now }

    context 'when processing diferent types of metrics' do
      context 'and the last weekly metric is of a diferent type' do
        let!(:daily_metric) do
          create(:metric,
                 interval: :daily,
                 name: :blog_visits,
                 ownable: user_project,
                 value_timestamp: current_time)
        end

        before do
          create(:metric,
                 interval: :weekly,
                 name: :review_turnaround,
                 ownable: user_project,
                 value_timestamp: current_time - 1.day)

          create(:metric,
                 interval: :daily,
                 name: :review_turnaround,
                 ownable: user_project,
                 value_timestamp: current_time)
        end

        let(:metric) { Metric.last }

        it 'creates a new metric with the respective daily metric type' do
          described_class.call
          expect(metric.name).to eq('blog_visits')
        end

        it 'changes the number of metrics created' do
          expect { described_class.call }.to change { Metric.count }.from(3).to(4)
        end

        it 'creates a metric for the correct entity' do
          described_class.call
          expect(metric.ownable.id).to eq(daily_metric.ownable.id)
        end
      end

      context 'and the last weekly metric is the same type' do
        let!(:previous_metric) do
          create(:metric,
                 interval: :weekly,
                 name: :review_turnaround,
                 ownable: user_project,
                 value_timestamp: current_time - 1.day)
        end

        before do
          create(:metric,
                 interval: :daily,
                 name: :review_turnaround,
                 ownable: user_project,
                 value_timestamp: current_time)
        end

        it 'updates the previous metric' do
          expect { described_class.call }.to change { previous_metric.reload.value }
        end

        it 'does not create a new one' do
          expect { described_class.call }.not_to change { Metric.count }
        end
      end
    end
  end
end
