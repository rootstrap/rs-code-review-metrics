require 'rails_helper'

RSpec.describe Processors::OpenSourceProjectViewsUpdater do
  describe '.call' do
    let(:project) { create(:project, :open_source) }
    let(:repository_views_payload) { create(:repository_views_payload) }

    before do
      stub_repository_views(project.name, repository_views_payload)
    end

    it 'generates visits metrics for the given project' do
      expect { described_class.call(project) }
        .to change {
          Metric.where(
            name: Metric.names[:open_source_visits],
            interval: Metric.intervals[:weekly]
          ).count
        }
        .by(repository_views_payload['views'].count)
    end

    context 'when the project already has some views metrics' do
      let(:old_views) { 3 }
      let(:this_week_views_payload) { repository_views_payload['views'].last }
      let(:this_week_timestamp) { this_week_views_payload['timestamp'] }
      let(:new_views) { this_week_views_payload['uniques'] }
      let(:this_week_metric) do
        Metric.find_by(
          name: Metric.names[:open_source_visits],
          interval: Metric.intervals[:weekly],
          ownable: project,
          value_timestamp: this_week_timestamp
        )
      end

      before do
        repository_views_payload['views'].each do |views_payload|
          Metric.create(
            name: Metric.names[:open_source_visits],
            interval: Metric.intervals[:weekly],
            ownable: project,
            value: old_views,
            value_timestamp: views_payload['timestamp']
          )
        end
      end

      it 'updates the last metric value' do
        expect { described_class.call(project) }
          .to change { this_week_metric.reload.value }
          .from(old_views)
          .to(new_views)
      end

      it 'only tries to update the last metric' do
        expect(Metric).to receive(:find_or_initialize_by).once.and_call_original

        described_class.call(project)
      end
    end
  end
end
