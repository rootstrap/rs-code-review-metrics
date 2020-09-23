require 'rails_helper'

RSpec.describe Metrics::Weekly::AllMetrics do
  describe '.call' do
    let(:user_project) { create(:users_project) }

    before do
      travel_to Time.zone.parse('2020-05-07').end_of_day
    end

    let!(:current_time) { Time.zone.now }

    context 'when processing diferent types of metrics' do
      context 'and the last weekly metric is of a diferent type' do
        let!(:daily_metric) do
          create(:metric,
                 interval: :daily,
                 name: :blog_visits,
                 value: 3600,
                 ownable: user_project,
                 value_timestamp: current_time)
        end

        before do
          create(:metric,
                 interval: :weekly,
                 name: :review_turnaround,
                 value: 1800,
                 ownable: user_project,
                 value_timestamp: current_time - 1.day)

          create(:metric,
                 interval: :daily,
                 name: :review_turnaround,
                 value: 1800,
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

    context 'when calculating the average for the past and current metrics in current week ' do
      let(:backend_department) { Department.find_by(name: 'backend') }
      let(:frontend_department) { Department.find_by(name: 'frontend') }
      let(:correct_average_value) { (1800 + 2700 + 3600) / 3 }

      context 'for departments' do
        before do
          create(:metric, interval: :daily,
                          name: :merge_time,
                          value: 1800,
                          ownable: frontend_department,
                          value_timestamp: current_time)
          create(:metric, interval: :daily,
                          name: :merge_time,
                          value: 1800,
                          ownable: backend_department,
                          value_timestamp: current_time)
          create(:metric, interval: :daily,
                          name: :merge_time,
                          value: 2700,
                          ownable: backend_department,
                          value_timestamp: current_time - 2.days)
          create(:metric, interval: :daily,
                          name: :merge_time,
                          value: 3600,
                          ownable: backend_department,
                          value_timestamp: current_time - 3.days)
        end

        let(:backend_weekly_metrics_count) do
          Metric.where(interval: :weekly, ownable_id: 1).count
        end
        let(:frontend_weekly_metrics_count) do
          Metric.where(interval: :weekly, ownable_id: 2).count
        end

        it 'generates two news metricss' do
          expect { described_class.call }.to change { Metric.count }.from(4).to(6)
        end

        it 'generates only one weekly metric for backend department' do
          described_class.call
          expect(backend_weekly_metrics_count).to eq(1)
        end

        it 'generates only one weekly metric for frontend department' do
          described_class.call
          expect(frontend_weekly_metrics_count).to eq(1)
        end

        it 'generates a new metric with the correct value' do
          described_class.call
          expect(Metric.last.value.seconds).to eq(correct_average_value)
        end
      end
    end
  end
end
