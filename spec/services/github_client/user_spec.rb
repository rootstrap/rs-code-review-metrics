require 'rails_helper'

RSpec.describe GithubClient::User do
  describe '#repositories' do
    let(:username) { 'hvilloria' }
    subject { described_class.new(username) }

    context 'when there are repos for the given user' do
      let!(:repositories_payload) do
        create(:github_api_client_repositories_payload)
      end

      before { stub_get_repos_from_user(username, repositories_payload) }

      it 'returns an array with the data' do
        expect(subject.repositories).not_to be_empty
      end
    end

    context 'when there are not repos for the given user' do
      before { stub_get_repos_from_user(username) }

      it 'returns an empty array' do
        expect(subject.repositories).to be_empty
      end
    end
  end
end
