require 'rails_helper'

RSpec.describe ActionHandlers::Push do
  describe '.call' do
    let(:push_payload) { create(:push_payload) }
    let(:push) { create(:push) }

    subject(:handle_action) { described_class.call(payload: push_payload, entity: push) }

    context 'when the push has an associated pull request' do
      let!(:pull_request) { create(:pull_request, pushes: [push]) }
      let(:pull_request_file_payload) { create(:pull_request_file_payload) }
      let(:additions) { pull_request_file_payload['additions'] }

      before { stub_pull_request_files_with_pr(pull_request, [pull_request_file_payload]) }

      it 'updates its pull request size value' do
        handle_action

        expect(push.pull_request.size).to eq(additions)
      end
    end

    context 'when the push does not have an associated pull request' do
      it 'does not update any Pull Request Size' do
        expect(Builders::PullRequestSize).not_to receive(:call)

        handle_action
      end
    end
  end
end
