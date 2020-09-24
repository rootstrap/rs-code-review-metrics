require 'rails_helper'

RSpec.describe GithubClient::User do
  describe '#pull_request_events' do
    let(:username) { 'hvilloria' }
    subject { described_class.new(username) }

    context 'when there are events for the given user' do
      let!(:pull_request_events_payload) do
        create(:gitub_api_client_pull_requests_events_payload)
      end

      before { stub_get_pull_requests_events(username, pull_request_events_payload) }

      it 'returns an array with the data' do
        expect(subject.pull_request_events).not_to be_empty
      end
    end

    context 'when there are not repos for the given user' do
      before { stub_get_pull_requests_events(username) }

      it 'returns an empty array' do
        expect(subject.pull_request_events).to be_empty
      end
    end
  end
end
