require 'rails_helper'

RSpec.describe Processors::OpenSourceProjectViewsUpdater do
  describe '.call' do
    let!(:open_source_project) { create(:project, :open_source) }
    let(:open_source_repository_views_payload) { create(:repository_views_payload) }
    let!(:private_project) { create(:project, is_private: true) }
    let(:private_repository_views_payload) { create(:repository_views_payload) }

    before do
      stub_repository_views(private_project.name, private_repository_views_payload)
      stub_repository_views(open_source_project.name, open_source_repository_views_payload)
    end

    it 'generates visits metrics for all open source projects' do
      expect { described_class.call }
        .to change {
          Metric.where(
            name: Metric.names[:open_source_visits],
            interval: Metric.intervals[:daily]
          ).count
        }
        .by(open_source_repository_views_payload['views'].count)
    end

    context 'when the project has already some views metrics' do
      let(:old_views) { 3 }
      let(:today_views_payload) { open_source_repository_views_payload['views'].last }
      let(:today_timestamp) { today_views_payload['timestamp'] }
      let(:new_views) { today_views_payload['uniques'] }
      let(:today_metric) do
        Metric.find_by(
          name: Metric.names[:open_source_visits],
          interval: Metric.intervals[:daily],
          ownable: open_source_project,
          value_timestamp: today_timestamp
        )
      end

      before do
        open_source_repository_views_payload['views'].each do |views_payload|
          Metric.create(
            name: Metric.names[:open_source_visits],
            interval: Metric.intervals[:daily],
            ownable: open_source_project,
            value: old_views,
            value_timestamp: views_payload['timestamp']
          )
        end
      end

      it 'updates the last metric value' do
        expect { described_class.call }
          .to change { today_metric.reload.value }
          .from(old_views)
          .to(new_views)
      end

      it 'only tries to update the last metric' do
        expect(Metric).to receive(:find_or_initialize_by).once.and_call_original

        described_class.call
      end
    end
  end
end
