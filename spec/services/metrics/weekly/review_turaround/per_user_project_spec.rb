require 'rails_helper'

RSpec.describe Metrics::Weekly::ReviewTurnaround::PerUserProject do
  describe '.call' do
    let(:project) { create(:project) }
    let(:users_project) { create(:users_project, project: project) }

    before do
      travel_to Time.zone.parse('2020-04-29')
    end

    after do
      travel_back
    end

    let!(:current_time) { Time.zone.now }

    context 'generating weekly metric' do
      context 'for a user who has made his first review' do
        let!(:daily_metric) do
          create(:metric, ownable: users_project, value_timestamp: Time.zone.today)
        end

        let(:weekly_metric_just_created) { Metric.find_by(interval: :weekly) }

        it 'creates the metric with the same value the current daily metric' do
          described_class.call
          expect(weekly_metric_just_created.value).to eq(daily_metric.value)
        end

        it 'creates just one weekly metric per daily metric' do
          expect { described_class.call }.to change { Metric.count }.by(1)
        end
      end

      context 'for a user who has previous reviews' do
        before do
          create(:metric,
                 ownable: users_project,
                 value: 120,
                 value_timestamp: current_time - 2.days)
          create(:metric,
                 ownable: users_project,
                 value: 60,
                 value_timestamp: current_time - 1.day)
        end

        let!(:weekly_metric) do
          create(:metric,
                 ownable: users_project,
                 value_timestamp: (current_time - 1.day),
                 value: 90,
                 interval: :weekly)
        end

        let!(:daily_metric) do
          create(:metric,
                 ownable: users_project,
                 value: 60,
                 value_timestamp: current_time)
        end

        let(:current_number_day) { 3 }

        let!(:avg) { 80 }

        it 'updates the previously metric created' do
          expect { described_class.call }.to change { weekly_metric.reload.value }.from(90).to(80)
        end

        it 'does not create a new metric' do
          expect { described_class.call }.not_to change { Metric.count }
        end

        it 'does an average between weekly metric, current daily metric and the number day' do
          described_class.call
          expect(weekly_metric.reload.value).to eq(avg)
        end
      end

      context 'for a user that just had two reviews in the last three days' do
        let!(:last_weekly_metric) do
          create(:metric,
                 ownable: users_project,
                 value: 60,
                 value_timestamp: current_time - 2.days,
                 interval: :weekly)
        end

        let!(:current_daily_metric) do
          create(:metric,
                 ownable: users_project,
                 value: 60,
                 value_timestamp: current_time)
        end

        before do
          create(:metric,
                 ownable: users_project,
                 value: 60,
                 value_timestamp: current_time - 2.days)
        end

        let!(:avg) { 60 }

        it 'calculates the average for all the daily metrics in current week' do
          described_class.call
          expect(Metric.last.value).to eq(avg)
        end
      end
    end
  end
end
