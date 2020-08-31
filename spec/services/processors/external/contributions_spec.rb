require 'rails_helper'

RSpec.describe Processors::External::Contributions do
  let!(:user) { create(:user, login: 'hvilloria') }
  context 'when there are repos for the given username' do
    before do
      stub_get_repos_from_user(user.login)
      allow(Builders::ExternalProject).to receive(:call) {}
      allow(Processors::External::PullRequests).to receive(:call) {}
    end

    it 'process the projects returned by the API' do
      expect(Builders::ExternalProject).to receive(:call).twice
      described_class.call
    end

    it 'process pull requests belonging to the given project' do
      expect(Processors::External::PullRequests).to receive(:call).twice
      described_class.call
    end
  end
  context 'when there are no repos for the given username' do
    before do
      stub_get_repos_from_user(user.login, true)
    end

    it 'process the projects returned by the API' do
      expect(Builders::ExternalProject).not_to receive(:call)
      described_class.call
    end

    it 'process pull requests belonging to the given project' do
      expect(Processors::External::PullRequests).not_to receive(:call)
      described_class.call
    end
  end
end
