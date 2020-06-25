require 'rails_helper'

RSpec.describe Processors::ProjectPrivacyBackfiller do
  describe '.call' do
    let(:project) { create(:project, private: nil) }
    let!(:event) { create(:event, project: project, data: check_run_payload) }
    let(:check_run_payload) do
      create(:check_run_payload, repository: repository_payload['repository'])
    end
    let(:repository_payload) { create(:repository_payload, is_private: true) }

    it 'updates the privacy for every project' do
      expect { described_class.call }.to change { project.reload.private }.from(nil).to(true)
    end
  end
end
