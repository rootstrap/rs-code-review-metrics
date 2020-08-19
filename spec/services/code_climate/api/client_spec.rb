require 'rails_helper'

describe CodeClimate::Api::Client do
  describe '#repository_by_slug' do
    let(:project) { create(:project) }
    let(:github_slug) do
      "#{CodeClimate::UpdateProjectService::CODE_CLIMATE_API_ORG_NAME}/#{project.name}"
    end

    context 'when the request succeeds' do
      before do
        on_request_repository(
          project_name: project.name,
          respond: { status: 200, body: code_climate_repository_json }
        )
      end

      context 'and has repository data' do
        let(:code_climate_repository_json) do
          create(:code_climate_repository_payload, name: project.name)
        end

        it 'returns a Repository with the data' do
          expect(subject.repository_by_slug(github_slug: github_slug).repository_id)
            .to eq(code_climate_repository_json['data'].first['id'])
        end
      end

      context 'but has no repository data' do
        let(:code_climate_repository_json) do
          create(:code_climate_repository_payload, data: [])
        end

        it 'returns nil' do
          expect(subject.repository_by_slug(github_slug: github_slug)).to be_nil
        end
      end
    end

    context 'when the request fails' do
      before do
        on_request_repository(
          project_name: project.name,
          respond: { status: 404 }
        )
      end

      it 'raises a Faraday error' do
        expect { subject.repository_by_slug(github_slug: github_slug) }
          .to raise_error Faraday::Error
      end
    end
  end

  describe '#snapshot' do
    let(:project) { create(:project) }
    let(:code_climate_repository_json) do
      create(:code_climate_repository_payload, name: project.name)
    end
    let(:repo_json) { code_climate_repository_json['data'].first }
    let(:repo_id) { repo_json['id'] }
    let(:snapshot_id) do
      repo_json['relationships']['latest_default_branch_snapshot']['data']['id']
    end

    context 'when the request succeeds' do
      let(:code_climate_snapshot_json) do
        create(:code_climate_snapshot_payload, id: snapshot_id)
      end

      before do
        on_request_snapshot(
          repo_id: repo_id,
          snapshot_id: snapshot_id,
          respond: { status: 200, body: code_climate_snapshot_json }
        )
      end

      it 'returns a snapshot with the data' do
        expect(subject.snapshot(repo_id: repo_id, snapshot_id: snapshot_id).send(:snapshot_id))
          .to eq(snapshot_id)
      end
    end

    context 'when the request fails' do
      before do
        on_request_snapshot(
          repo_id: repo_id,
          snapshot_id: snapshot_id,
          respond: { status: 404 }
        )
      end

      it 'raises a Faraday error' do
        expect { subject.snapshot(repo_id: repo_id, snapshot_id: snapshot_id) }
          .to raise_error Faraday::Error
      end
    end
  end

  describe '#snapshot_issues' do
    let(:project) { create(:project) }
    let(:code_climate_repository_json) do
      create(:code_climate_repository_payload, name: project.name)
    end
    let(:repo_json) { code_climate_repository_json['data'].first }
    let(:repo_id) { repo_json['id'] }
    let(:snapshot_id) do
      repo_json['relationships']['latest_default_branch_snapshot']['data']['id']
    end

    context 'when the request succeeds' do
      let(:code_climate_snapshot_issues_json) do
        create(:code_climate_snapshot_issues_payload, status: ['invalid'])
      end

      before do
        on_request_issues(
          repo_id: repo_id,
          snapshot_id: snapshot_id,
          respond: { status: 200, body: code_climate_snapshot_issues_json }
        )
      end

      it 'returns the snapshot issues' do
        expect(subject.snapshot_issues(repo_id: repo_id, snapshot_id: snapshot_id))
          .to all(satisfy(&:invalid?))
      end
    end

    context 'when the request fails' do
      before do
        on_request_issues(
          repo_id: repo_id,
          snapshot_id: snapshot_id,
          respond: { status: 404 }
        )
      end

      it 'raises a Faraday error' do
        expect { subject.snapshot_issues(repo_id: repo_id, snapshot_id: snapshot_id) }
          .to raise_error Faraday::Error
      end
    end
  end
end
