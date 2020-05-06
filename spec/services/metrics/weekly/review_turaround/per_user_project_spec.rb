require 'rails_helper'

RSpec.describe Metrics::Weekly::ReviewTurnaround::PerUserProject do
  describe '.call' do
    let(:project) { create(:project) }
    let(:users_project) { create(:users_project, project: project) }
    let(:second_users_project) { create(:users_project, project: project) }
    let(:third_users_project) { create(:users_project, project: project) }

    context 'generating a weekly metric for a user who has made his first review' do
      let!(:metric) { create(:metric, ownable: users_project, value_timestamp: Time.zone.today) }
      let(:weekly_metric_just_created) { Metric.find_by(interval: :weekly) }
      it 'creates the metric with the same value the current daily metric' do
        described_class.call
        expect(metric.value).to eq(weekly_metric_just_created.value)
      end

      it 'creates just one weekly metric per daily metric' do
        expect { described_class.call }.to change { Metric.count }.by(1)
      end
    end

    context 'generating a weekly metric for a user who has previous reviews' do
      let!(:current_time) { Time.zone.parse('2020-04-29') }

      let!(:weekly_metric) do
        create(:metric,
               ownable: users_project,
               value_timestamp: (current_time - 1.day),
               value: 120,
               interval: :weekly)
      end

      let!(:daily_metric) do
        create(:metric,
               ownable: users_project,
               value: 60,
               value_timestamp: current_time)
      end

      let(:current_number_day) { current_time.wday }

      let!(:avg) { (weekly_metric.value + daily_metric.value) / current_number_day }

      before do
        allow(Time).to receive(:now) { current_time }
      end

      it 'updates the previously metric created' do
        expect { described_class.call }.to change { weekly_metric.reload.value }.from(120).to(60)
      end

      it 'does not create a new metric' do
        expect { described_class.call }.not_to change { Metric.count }
      end

      it 'does a average between previous weekly metric, current daily metric and the number day' do
        described_class.call
        expect(weekly_metric.reload.value).to eq(avg)
      end
    end
  end
end
