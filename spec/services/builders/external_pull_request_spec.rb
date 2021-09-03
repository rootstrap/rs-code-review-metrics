require 'rails_helper'

RSpec.describe Builders::ExternalPullRequest do
  describe '.call' do
    context 'when there is already a pull request' do
      let!(:pull_request) { create(:external_pull_request, state: 'open') }

      let(:pull_request_payload) do
        build(
          :github_api_client_pull_request_payload,
          pull_request: pull_request,
          number: pull_request.number,
          merged: true
        ).deep_symbolize_keys
      end

      before { stub_get_pull_request(pull_request, pull_request_payload) }

      it 'returns that pull request' do
        expect(described_class.call(pull_request_payload).id)
          .to eq(pull_request.id)
      end

      it 'does not create a new external pull request' do
        expect { described_class.call(pull_request_payload) }
          .not_to change { ExternalPullRequest.count }
      end

      it 'updates pull requests state to merged' do
        expect { described_class.call(pull_request_payload) }
          .to change { pull_request.reload.state }.from('open').to('merged')
      end
    end

    context 'when there is no pull request created with a given id' do
      let(:project_owner) { 'rootstrap' }
      let(:project_name) { 'rs-code-review-metrics' }
      let(:project_full_name) { "#{project_owner}/#{project_name}" }
      let(:pull_request_number) { 111 }
      let(:repository) { ExternalRepository.new(full_name: project_full_name) }

      let(:repository_payload) do
        build(:repository_payload, name: project_name, owner: { login: project_owner })
      end

      let(:pull_request_data) do
        create(
          :github_api_client_pull_request_payload,
          number: pull_request_number,
          base_repo: repository_payload
        ).deep_symbolize_keys
      end

      let(:pull_request) do
        ExternalPullRequest.new(number: pull_request_number, external_repository: repository)
      end

      before { stub_get_pull_request(pull_request, pull_request_data) }

      subject { described_class.call(pull_request_data) }

      it 'returns a new external pull request created' do
        expect(subject.github_id).to eq(pull_request_data[:id])
      end

      it 'creates a new record' do
        expect { subject }.to change { ExternalPullRequest.count }.by(1)
      end

      it 'creates all attributes correctly' do
        expect(subject.github_id).to eq(pull_request_data[:id])
        expect(subject.html_url).to eq(pull_request_data[:html_url])
        expect(subject.body).to eq(pull_request_data[:body])
        expect(subject.title).to eq(pull_request_data[:title])
        expect(subject.opened_at).to eq(pull_request_data[:created_at])
        expect(subject.number).to eq(pull_request_data[:number])
        expect(subject.owner.login).to eq(pull_request_data[:user][:login])
      end

      describe 'pull request owner' do
        context 'when the owner has not been created' do
          it 'creates it' do
            expect { subject }.to change { User.count }.by(1)
          end
        end
      end
    end
  end

  describe Builders::ExternalPullRequest::FromUrlParams do
    describe '.call' do
      let(:project_owner) { 'rootstrap' }
      let(:project_name) { 'rs-code-review-metrics' }
      let(:project_full_name) { "#{project_owner}/#{project_name}" }
      let(:pull_request_number) { 111 }
      let(:repository) { ExternalRepository.new(full_name: project_full_name) }
      let(:pull_request) do
        ExternalPullRequest.new(number: pull_request_number, external_repository: repository)
      end
      let(:repository_payload) do
        build(:repository_payload, name: project_name, owner: { login: project_owner })
      end
      let(:pull_request_payload) do
        build(
          :github_api_client_pull_request_payload,
          number: pull_request_number,
          base_repo: repository_payload
        )
      end

      before { stub_get_pull_request(pull_request, pull_request_payload) }

      subject(:built_pull_request) { described_class.call(project_full_name, pull_request_number) }

      it 'creates a new ExternalPullRequest' do
        expect { subject }.to change { ExternalPullRequest.count }.by(1)
      end

      it 'returns the built ExternalPullRequest' do
        expect(built_pull_request.number).to eq pull_request_number
      end
    end
  end
end
