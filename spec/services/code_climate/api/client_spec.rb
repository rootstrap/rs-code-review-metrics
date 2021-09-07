require 'rails_helper'

describe CodeClimate::Api::Client do
  describe '#repository_by_slug' do
    let(:repository) { create(:repository) }
    let(:github_slug) do
      "#{CodeClimate::GetProjectSummary::CODE_CLIMATE_API_ORG_NAME}/#{repository.name}"
    end

    context 'when the request succeeds' do
      before do
        on_request_repository_by_slug(
          project_name: repository.name,
          respond: { status: 200, body: code_climate_repository_json }
        )
      end

      context 'and has repository data' do
        let(:code_climate_repository_json) do
          create(:code_climate_repository_by_slug_payload, name: repository.name)
        end

        it 'returns a Repository with the data' do
          expect(subject.repository_by_slug(github_slug: github_slug).send(:repository_id))
            .to eq(code_climate_repository_json['data'].first['id'])
        end
      end

      context 'but has no repository data' do
        let(:code_climate_repository_json) do
          create(:code_climate_repository_by_slug_payload, data: [])
        end

        it 'returns nil' do
          expect(subject.repository_by_slug(github_slug: github_slug)).to be_nil
        end
      end
    end

    context 'when the request fails' do
      before do
        on_request_repository_by_slug(
          project_name: repository.name,
          respond: { status: 404 }
        )
      end

      it 'raises a Faraday error' do
        expect { subject.repository_by_slug(github_slug: github_slug) }
          .to raise_error Faraday::Error
      end
    end
  end

  describe '#repository_by_repo_id' do
    let(:repository) { create(:repository) }
    let(:code_climate_repository_json) do
      create(:code_climate_repository_by_id_payload, name: repository.name)
    end
    let(:repo_id) { code_climate_repository_json['data']['id'] }

    context 'when the request succeeds' do
      before do
        on_request_repository_by_repo_id(
          repo_id: repo_id,
          respond: { status: 200, body: code_climate_repository_json }
        )
      end

      it 'returns a Repository with the data' do
        expect(subject.repository_by_repo_id(repo_id: repo_id).send(:repository_id))
          .to eq(repo_id)
      end
    end

    context 'when the request fails' do
      before do
        on_request_repository_by_repo_id(
          repo_id: repo_id,
          respond: { status: 404 }
        )
      end

      it 'raises a Faraday error' do
        expect { subject.repository_by_repo_id(repo_id: repo_id) }
          .to raise_error Faraday::Error
      end
    end
  end

  describe '#snapshot' do
    let(:repository) { create(:repository) }
    let(:code_climate_repository_json) do
      create(:code_climate_repository_by_slug_payload, name: repository.name)
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
    let(:repository) { create(:repository) }
    let(:code_climate_repository_json) do
      create(:code_climate_repository_by_slug_payload, name: repository.name)
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

  describe '#test_report' do
    let(:repository) { create(:repository) }
    let(:code_climate_repository_json) do
      create(:code_climate_repository_by_slug_payload, name: repository.name)
    end
    let(:repo_json) { code_climate_repository_json['data'].first }
    let(:repo_id) { repo_json['id'] }
    let(:test_report_id) do
      repo_json['relationships']['latest_default_branch_test_report']['data']['id']
    end

    context 'when the request succeeds' do
      let(:coverage) { 99.0 }
      let(:code_climate_test_report_json) do
        create(:code_climate_test_report_payload, id: test_report_id, coverage: coverage)
      end

      before do
        on_request_test_report(
          repo_id: repo_id,
          test_report_id: test_report_id,
          respond: { status: 200, body: code_climate_test_report_json }
        )
      end

      it 'returns a test_report with the data' do
        expect(subject.test_report(repo_id: repo_id, test_report_id: test_report_id).coverage)
          .to eq(coverage)
      end
    end

    context 'when the request fails' do
      before do
        on_request_test_report(
          repo_id: repo_id,
          test_report_id: test_report_id,
          respond: { status: 404 }
        )
      end

      it 'raises a Faraday error' do
        expect { subject.test_report(repo_id: repo_id, test_report_id: test_report_id) }
          .to raise_error Faraday::Error
      end
    end
  end
end
