require 'rails_helper'

RSpec.describe Processors::OpenSourceMetricsUpdater do
  describe '.call' do
    let(:project) { create(:project, :open_source) }
    let(:repository_views_payload) { create(:repository_views_payload) }
    let(:total_metrics_generated) { repository_views_payload['views'].count }

    before do
      stub_repository_views(project.name, repository_views_payload)
    end

    it 'generates open source visits metrics' do
      expect { described_class.call }
        .to change(Metric.where(ownable_type: Project.to_s), :count)
        .by(total_metrics_generated)
    end
  end
end
