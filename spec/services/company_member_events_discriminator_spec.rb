require 'rails_helper'

RSpec.describe CompanyMemberEventsDiscriminator do
  describe '.call' do
    let!(:user) { create(:user, login: 'hvilloria') }

    let(:event_repo_organization) do
      { repo: { id: 1, name: 'mycompany/project1' } }
    end

    let(:event_repo_user) do
      { repo: { id: 2, name: 'hvilloria/project2' } }
    end

    let(:event_repo_external) do
      { repo: { id: 3, name: 'guilleleop/project3' } }
    end

    let(:events) { [event_repo_organization, event_repo_user, event_repo_external] }

    before do
      stub_env('GITHUB_ORGANIZATION', 'mycompany')
    end

    it 'removes the projects from the organization' do
      expect(described_class.call(events)).not_to include(event_repo_organization)
    end

    it "removes the projects from organization's user" do
      expect(described_class.call(events)).not_to include(event_repo_user)
    end

    it 'does not remove a project from outside the organization' do
      expect(described_class.call(events)).to include(event_repo_external)
    end
  end
end
