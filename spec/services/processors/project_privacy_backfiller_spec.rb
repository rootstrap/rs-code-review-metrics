require 'rails_helper'

RSpec.describe Processors::ProjectPrivacyBackfiller do
  describe '.call' do
    let(:repository) { create(:repository, is_private: nil) }
    let!(:event) { create(:event, repository: repository, data: check_run_payload) }
    let(:check_run_payload) do
      create(:check_run_payload, repository: repository_payload)
    end
    let(:repository_payload) { create(:repository_payload, private: true) }

    it 'updates the privacy for every repository' do
      expect { described_class.call }.to change { repository.reload.is_private }.from(nil).to(true)
    end
  end
end
