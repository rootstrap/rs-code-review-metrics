require 'rails_helper'

describe CodeClimate::UpdateProjectService do
  subject { CodeClimate::UpdateProjectService }

  before do
    stub_request(:get, "#{base_url}/repos?github_slug=rootstrap/#{project.name}")
      .to_return(status: 200, body: JSON.generate(code_climate_repository_json))
    stub_request(:get, "#{base_url}/repos/#{repo_id}/snapshots/#{snapshot_id}")
      .to_return(status: 200, body: JSON.generate(code_climate_snapshot_json))
    stub_request(:get, "#{base_url}/repos/#{repo_id}/snapshots/#{snapshot_id}/issues")
      .to_return(status: 200, body: JSON.generate(code_climate_snapshot_issues_json))
  end

  let(:base_url) { 'https://api.codeclimate.com/v1' }
  let(:repo_id) { code_climate_repository_json['data'].first['id'] }
  let(:snapshot_id) { code_climate_snapshot_json['data']['id'] }

  let(:code_climate_repository_json) do
    build :code_climate_repository_payload,
          latest_default_branch_snapshot_id: code_climate_snapshot_json['data']['id']
  end
  let(:code_climate_snapshot_json) do
    build :code_climate_snapshot_payload,
          rate: 'A'
  end
  let(:code_climate_snapshot_issues_json) do
    build :code_climate_snapshot_issues_payload,
          status: %w[invalid wontfix invalid]
  end

  let(:project) { create :project, name: 'rs-code-review-metrics' }
  let(:update_project_code_climate_info) { subject.call(project) }

  context 'when the /repos call returns anything but 200' do
    before do
      stub_request(:get, "#{base_url}/repos?github_slug=rootstrap/#{project.name}")
        .to_return(status: 500)
    end

    it 'does not update a CodeClimateProjectMetric record' do
      expect { update_project_code_climate_info }.not_to change { CodeClimateProjectMetric.count }
    end
  end

  context 'when the /repos/:id/snapshots/ call returns anything but 200' do
    before do
      stub_request(:get, "#{base_url}/repos/#{repo_id}/snapshots/#{snapshot_id}")
        .to_return(status: 500)
    end

    it 'does not update a CodeClimateProjectMetric record' do
      expect { update_project_code_climate_info }.not_to change { CodeClimateProjectMetric.count }
    end
  end

  context 'when the /repos/:id/snapshots/issues call returns anything but 200' do
    before do
      stub_request(:get, "#{base_url}/repos/#{repo_id}/snapshots/#{snapshot_id}/issues")
        .to_return(status: 500)
    end

    it 'does not update a CodeClimateProjectMetric record' do
      expect { update_project_code_climate_info }.not_to change { CodeClimateProjectMetric.count }
    end
  end
end
