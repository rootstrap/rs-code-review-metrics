require 'rails_helper'

RSpec.describe ExternalContributionsProcessorJob do
  it 'executes external contributions processor' do
    expect(Processors::External::Contributions).to receive(:call)

    described_class.perform_now
  end

  context 'for a rootstrap member working on external repositories' do
    let(:user) { create(:user) }

    context 'with pull requests made for the first project' do
      let!(:pull_requests_events_payload) do
        [create(:github_api_client_pull_request_event_payload, username: user.login)]
      end
      let(:pull_request_payload) { pull_requests_events_payload.first['payload']['pull_request'] }
      let(:repo_id) { pull_request_payload['base']['repo']['id'] }

      before do
        stub_request(:get, %r{\Ahttps://api.github.com/repos/.*/pulls/.*\z})
          .to_return(
            body: JSON.generate(pull_request_payload),
            status: 200
          )
      end

      before do
        stub_get_pull_requests_events(user.login, pull_requests_events_payload)
      end

      it 'saves just the project with pull request associated' do
        described_class.perform_now
        expect(ExternalProject.last.github_id).to eq(repo_id)
      end

      it 'creates a external project record' do
        expect { described_class.perform_now }.to change { ExternalProject.count }.by(1)
      end
    end

    context 'with non pull request made' do
      before do
        stub_get_pull_requests_events(user.login)
      end

      let(:external_github_ids) { ExternalProject.pluck(:github_id) }

      it 'does not create any external project' do
        expect { described_class.perform_now }.not_to change { ExternalProject.count }
      end
    end
  end
end
