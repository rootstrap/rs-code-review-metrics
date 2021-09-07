require 'rails_helper'

RSpec.describe ExternalContributionsProcessorJob do
  it 'executes external contributions processor' do
    expect(Processors::External::Contributions).to receive(:call)

    described_class.perform_now
  end

  context 'for a rootstrap member working on external repositories' do
    let(:user) { create(:user, company_member_since: 1.day.ago) }

    context 'with pull requests made for the first repository' do
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

      it 'saves just the repository with pull request associated' do
        described_class.perform_now
        expect(ExternalRepository.last.github_id).to eq(repo_id)
      end

      it 'creates a external repository record' do
        expect { described_class.perform_now }.to change { ExternalRepository.count }.by(1)
      end
    end

    context 'with non pull request made' do
      before do
        stub_get_pull_requests_events(user.login)
      end

      let(:external_github_ids) { ExternalRepository.pluck(:github_id) }

      it 'does not create any external repository' do
        expect { described_class.perform_now }.not_to change { ExternalRepository.count }
      end
    end
  end
end
