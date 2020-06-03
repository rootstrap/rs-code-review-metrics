require 'rails_helper'

RSpec.describe Metrics::Weekly::AllMetrics do
  describe '.call' do
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

    context 'when processing same type of metric' do
      let!(:daily_metric) do
        create(:metric,
               interval: :daily,
               name: :merge_time,
               ownable: user_project,
               value_timestamp: current_time,
               value: 120)
      end

      before { Metrics::Weekly::AllMetrics.call }

      context 'and the first metric for that week was on thursday' do
        it 'creates the weekly metric with valuestimestamp on monday of that week' do
          expect(Metric.last.value_timestamp.monday?).to eq(true)
        end

        it 'creates a weekly metric with same value as daily metric' do
          expect(Metric.last.value).to eq(daily_metric.value)
        end
      end

      context 'and have metrics from tuesday to thursday' do
        let!(:weekly_metric_previously_created) do
          create(:metric,
                 interval: :daily,
                 name: :merge_time,
                 ownable: user_project,
                 value_timestamp: current_time.beginning_of_week,
                 value: 60)
        end

        it 'updates the metric that should have been created on monday of that week' do
          expect(Metric.last.value).to eq(60)
        end
      end
    end
  end
end
