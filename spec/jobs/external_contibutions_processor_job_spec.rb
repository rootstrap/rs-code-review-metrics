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
        create(:gitub_api_client_pull_requests_events_payload, actor: { login: user.login })
      end

      before do
        stub_get_pull_requests_events(user.login, pull_requests_events_payload)
      end

      it 'saves just the project with pull request associated' do
        described_class.perform_now
        expect(ExternalProject.last.github_id)
          .to eq(pull_requests_events_payload.first['repo']['id'])
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
