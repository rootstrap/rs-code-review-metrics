require 'rails_helper'

RSpec.describe Processors::OpenSourceMetricsUpdater do
  describe '.call' do
    let!(:private_project) { create(:project, is_private: true) }
    let!(:open_source_project) { create(:project, :open_source) }
    let(:open_source_repository_views_payload) { create(:repository_views_payload) }
    let(:total_metrics_generated) { open_source_repository_views_payload['views'].count }

    before do
      stub_successful_repository_views(open_source_project, open_source_repository_views_payload)
    end

    it 'generates visits metrics for all open source projects' do
      expect { described_class.call }
        .to change(Metric.where(ownable_type: Project.to_s), :count)
        .by(total_metrics_generated)
    end
  end
end
