require 'rails_helper'

RSpec.describe Processors::External::PullRequests do
  let!(:external_project) { build(:external_project) }
  let(:user) { create(:user, login: 'hvilloria') }
  context 'when user has pull request in a given project' do
    before do
      stub_get_pull_requests(external_project)
    end

    it 'saves given project' do
      expect { described_class.call(external_project, user.login) }
        .to change { ExternalProject.count }.by(1)
    end

    it 'saves pull requests where the username is owner' do
      expect { described_class.call(external_project, user.login) }
        .to change { ExternalPullRequest.count }.by(1)
    end
  end
  context 'when user doest not has pull request in a given project' do
    before do
      stub_get_pull_requests(external_project, true)
    end

    it 'does not save given project' do
      expect { described_class.call(external_project, user.login) }
        .not_to change { ExternalProject.count }
    end

    it 'does not save the pull request' do
      expect { described_class.call(external_project, user.login) }
        .not_to change { ExternalPullRequest.count }
    end
  end
end
