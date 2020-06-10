require 'rails_helper'

describe CodeClimate::UpdateProjectService do
  subject { CodeClimate::UpdateProjectService }

  before do
    base_url = 'https://api.codeclimate.com/v1'
    repo_id = code_climate_repository_json['data']['id']
    snapshot_id = code_climate_snapshot_json['data']['id']
    stub_request(:get, "#{base_url}/repos/#{repo_id}/snapshots/#{snapshot_id}")
      .to_return(status: 200, body: JSON.generate(code_climate_snapshot_json))
    stub_request(:get, "#{base_url}/repos/#{repo_id}/snapshots/#{snapshot_id}/issues")
      .to_return(status: 200, body: JSON.generate(code_climate_snapshot_issues_json))
  end

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
  let(:yesterday) { Time.zone.yesterday.beginning_of_day }
  let(:today) { Time.zone.today.beginning_of_day }

  context 'with a project not registered in CodeClimate' do
    before do
      stub_request(:get, "https://api.codeclimate.com/v1/repos?github_slug=#{project.name}")
        .to_return(status: 404)
    end

    it 'does not create a CodeClimateProjectMetric record' do
      expect { update_project_code_climate_info }.not_to change { CodeClimateProjectMetric.count }
    end
  end

  context 'with a project registered in CodeClimate that has not been updated before' do
    before do
      stub_request(:get, "https://api.codeclimate.com/v1/repos?github_slug=#{project.name}")
        .to_return(status: 200, body: JSON.generate(code_climate_repository_json))
    end

    it 'creates a CodeClimateProjectMetric record' do
      expect { update_project_code_climate_info }.to change { CodeClimateProjectMetric.count }.by(1)
    end

    it 'sets the new CodeClimate rate for the project' do
      update_project_code_climate_info
      expect(CodeClimateProjectMetric.first.code_climate_rate).to eq('A')
    end

    it 'sets the new CodeClimate invalid_issues_count for the project' do
      update_project_code_climate_info
      expect(CodeClimateProjectMetric.first.invalid_issues_count).to eq(2)
    end

    it 'sets the new CodeClimate wont_fix_issues_count for the project' do
      update_project_code_climate_info
      expect(CodeClimateProjectMetric.first.wont_fix_issues_count).to eq(1)
    end
  end

  context 'with a project registered in CodeClimate that is outdated' do
    before do
      existing_code_climate_project_metric

      stub_request(:get, "https://api.codeclimate.com/v1/repos?github_slug=#{project.name}")
        .to_return(status: 200, body: JSON.generate(code_climate_repository_json))
    end

    let(:existing_code_climate_project_metric) do
      create :code_climate_project_metric,
             project: project,
             code_climate_rate: 'C',
             invalid_issues_count: 0,
             wont_fix_issues_count: 0,
             updated_at: yesterday
    end

    it 'does not create a new CodeClimateProjectMetric record' do
      expect { update_project_code_climate_info }.not_to change { CodeClimateProjectMetric.count }
    end

    it 'sets the new CodeClimate rate for the project' do
      update_project_code_climate_info
      expect(CodeClimateProjectMetric.first.code_climate_rate).to eq('A')
    end

    it 'sets the new CodeClimate invalid_issues_count for the project' do
      update_project_code_climate_info
      expect(CodeClimateProjectMetric.first.invalid_issues_count).to eq(2)
    end

    it 'sets the new CodeClimate wont_fix_issues_count for the project' do
      update_project_code_climate_info
      expect(CodeClimateProjectMetric.first.wont_fix_issues_count).to eq(1)
    end
  end

  context 'with a project registered in CodeClimate that is up to date' do
    before do
      existing_code_climate_project_metric

      stub_request(:get, "https://api.codeclimate.com/v1/repos?github_slug=#{project.name}")
        .to_return(status: 200, body: JSON.generate(code_climate_repository_json))
    end

    let(:existing_code_climate_project_metric) do
      create :code_climate_project_metric,
             project: project,
             code_climate_rate: 'C',
             invalid_issues_count: 0,
             wont_fix_issues_count: 0,
             updated_at: today
    end

    it 'does not create a new CodeClimateProjectMetric record' do
      expect { update_project_code_climate_info }.not_to change { CodeClimateProjectMetric.count }
    end

    it 'does not call the API client' do
      expect(CodeClimate::Api::Client).not_to receive(:new)
      update_project_code_climate_info
    end

    it 'does not update the CodeClimateProjectMetric record for the project' do
      update_project_code_climate_info
      expect(CodeClimateProjectMetric.first.updated_at).to eq(today)
    end
  end
end
