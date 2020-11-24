require 'rails_helper'

RSpec.describe GithubClient::Organization do
  describe '#repositories' do
    let(:repository_payload) { create(:repository_payload) }

    before do
      stub_organization_repositories([repository_payload])
    end

    it 'returns rootstrap repositories' do
      expect(subject.repositories).to contain_exactly(repository_payload)
    end

    context 'when there is more than one page of results' do
      let(:repository_payload_2) { create(:repository_payload) }
      let(:repository_payloads) { [repository_payload, repository_payload_2] }

      before do
        stub_organization_repositories(repository_payloads, results_per_page: 1)
      end

      it 'returns the repositories from all pages' do
        expect(subject.repositories).to match_array(repository_payloads)
      end
    end
  end

  describe '#members' do
    let(:members_payload) { create(:members_payload) }

    before do
      stub_organization_members([members_payload])
    end

    it 'returns rootstrap members' do
      expect(subject.members).to contain_exactly(members_payload['login'])
    end

    context 'when there is more than one page of results' do
      let(:members_payload_2) { create(:members_payload) }
      let(:members_payloads) { [members_payload, members_payload_2] }

      before do
        stub_organization_members(members_payloads, results_per_page: 1)
      end

      it 'returns the members from all pages' do
        expect(subject.members).to match_array(members_payloads.map { |user| user['login'] })
      end
    end
  end
end
