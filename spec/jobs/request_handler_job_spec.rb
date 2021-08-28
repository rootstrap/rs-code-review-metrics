require 'rails_helper'

describe RequestHandlerJob do
  describe '#perform' do
    let!(:payload) { (create :full_pull_request_payload) }
    let!(:event) { 'pull_request' }

    it 'correctly initializes the Github service and calls it' do
      expect_any_instance_of(GithubService)
        .to receive(:call)
        .once

      described_class.perform_now(payload, event)
    end
  end
end
