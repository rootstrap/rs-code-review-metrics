require 'rails_helper'

RSpec.describe Builders::Events::Push do
  describe '.call' do
    let(:push_payload) { create(:push_payload) }
    let(:repository_payload) { push_payload['repository'] }
    let(:user_payload) { push_payload['sender'] }

    subject(:build_push) { described_class.call(payload: push_payload) }

    it 'creates a new Push' do
      expect { build_push }.to change { Events::Push.count }.by(1)
    end

    it 'creates or assigns the correct references to it' do
      built_push = build_push
      expect(built_push.repository.github_id).to eq(repository_payload['id'])
      expect(built_push.sender.github_id).to eq(user_payload['id'])
      expect(built_push.sender.repositories).to include(built_push.repository)
    end

    context 'when there is a pull request for the pushed branch' do
      let(:branch) { 'add_super_feature' }
      let(:push_payload) { create(:push_payload, branch: branch) }
      let(:repository) { create(:repository, github_id: repository_payload['id']) }
      let!(:pull_request) do
        create(:pull_request, branch: branch, state: pr_status, repository: repository)
      end

      context 'and it is open' do
        let(:pr_status) { Events::PullRequest.states[:open] }

        it 'associates that pull request to the created push' do
          expect(build_push.pull_request).to eq(pull_request)
        end
      end

      context 'and it is closed' do
        let(:pr_status) { Events::PullRequest.states[:closed] }

        it 'does not associate any pull request to the push' do
          expect(build_push.pull_request).not_to be_present
        end
      end
    end

    context 'when the push has a tag ref' do
      let(:push_payload) { create(:push_payload, ref: 'refs/tags/1.0.0') }

      it 'does not look for any pull request to associate to it' do
        expect(Events::PullRequest).not_to receive(:find_by)

        build_push
      end
    end
  end
end
