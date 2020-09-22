require 'rails_helper'

describe CodeClimate::UpdateProjectService do
  subject { CodeClimate::UpdateProjectService }

  before do
    on_request_snapshot(repo_id: repo_id,
                        snapshot_id: snapshot_id,
                        respond: { status: 200, body: code_climate_snapshot_json })

    on_request_issues(repo_id: repo_id,
                      snapshot_id: snapshot_id,
                      respond: { status: 200, body: code_climate_snapshot_issues_json })

    on_request_test_report(repo_id: repo_id,
                           test_report_id: test_report_id,
                           respond: { status: 200, body: code_climate_test_report_json })
  end

  let(:repo_id) { repository_payload['data']['id'] }
  let(:snapshot_id) { code_climate_snapshot_json['data']['id'] }
  let(:test_report_id) { code_climate_test_report_json['data']['id'] }

  let(:repository_payload) do
    build :code_climate_repository_payload,
          latest_default_branch_snapshot_id: snapshot_id,
          latest_default_branch_test_report_id: test_report_id
  end
  let(:code_climate_snapshot_json) do
    build :code_climate_snapshot_payload,
          rate: 'A'
  end
  let(:code_climate_snapshot_issues_json) do
    build :code_climate_snapshot_issues_payload,
          status: %w[invalid wontfix invalid new open confirmed]
  end
  let(:code_climate_test_report_json) do
    build :code_climate_test_report_payload,
          coverage: coverage
  end

  let(:project) { create :project, name: 'rs-code-review-metrics' }
  let(:update_project_code_climate_info) { subject.call(project) }
  let(:yesterday) { Time.zone.yesterday.beginning_of_day }
  let(:today) { Time.zone.today.beginning_of_day }
  let(:coverage) { 99.0 }

  context 'with a project not registered in CodeClimate' do
    before do
      on_request_repository_by_slug(
        project_name: project.name,
        respond: { status: 200, body: code_climate_repository_json }
      )
    end

    let(:code_climate_repository_json) do
      build :code_climate_repository_by_slug_payload,
            repository_payload: nil
    end

    it 'does not create a CodeClimateProjectMetric record' do
      expect { update_project_code_climate_info }.not_to change { CodeClimateProjectMetric.count }
    end
  end

  context 'with a project registered in CodeClimate that has not been updated before' do
    before do
      on_request_repository_by_slug(
        project_name: project.name,
        respond: { status: 200, body: code_climate_repository_json }
      )
    end

    let(:code_climate_repository_json) do
      build :code_climate_repository_by_slug_payload,
            repository_payload: repository_payload['data']
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

    it 'sets the new CodeClimate open_issues_count for the project' do
      update_project_code_climate_info
      expect(CodeClimateProjectMetric.first.open_issues_count).to eq(3)
    end

    it 'sets the new CodeClimate repository id for the project' do
      update_project_code_climate_info
      expect(CodeClimateProjectMetric.first.cc_repository_id).to eq(repo_id)
    end

    it 'sets the new CodeClimate test coverage for the project' do
      update_project_code_climate_info
      expect(CodeClimateProjectMetric.first.test_coverage).to eq(coverage)
    end
  end

  context 'with a project registered in CodeClimate that is outdated' do
    before do
      existing_code_climate_project_metric

      on_request_repository_by_repo_id(
        repo_id: repo_id,
        respond: { status: 200, body: code_climate_repository_json }
      )
    end

    let(:code_climate_repository_json) do
      build :code_climate_repository_by_id_payload,
            repository_payload: repository_payload['data']
    end

    let(:existing_code_climate_project_metric) do
      create :code_climate_project_metric,
             project: project,
             code_climate_rate: 'C',
             invalid_issues_count: 0,
             wont_fix_issues_count: 0,
             open_issues_count: 0,
             cc_repository_id: repo_id,
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

    it 'sets the new CodeClimate open_issues_count for the project' do
      update_project_code_climate_info
      expect(CodeClimateProjectMetric.first.open_issues_count).to eq(3)
    end

    it 'sets the new CodeClimate repository id for the project' do
      update_project_code_climate_info
      expect(CodeClimateProjectMetric.first.cc_repository_id).to eq(repo_id)
    end

    it 'sets the new CodeClimate test coverage for the project' do
      update_project_code_climate_info
      expect(CodeClimateProjectMetric.first.test_coverage).to eq(coverage)
    end
  end

  context 'with a project registered in CodeClimate that is up to date' do
    before do
      existing_code_climate_project_metric

      on_request_repository_by_repo_id(
        repo_id: repo_id,
        respond: { status: 200, body: code_climate_repository_json }
      )
    end

    let(:code_climate_repository_json) do
      build :code_climate_repository_by_id_payload,
            repository_payload: repository_payload['data']
    end

    let(:existing_code_climate_project_metric) do
      create :code_climate_project_metric,
             project: project,
             code_climate_rate: 'C',
             invalid_issues_count: 0,
             wont_fix_issues_count: 0,
             cc_repository_id: repo_id,
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

  describe 'a project having incomplete info on Code Climate' do
    let(:code_climate_repository_json) do
      build :code_climate_repository_by_slug_payload,
            repository_payload: repository_payload['data']
    end

    before do
      on_request_repository_by_slug(
        project_name: project.name,
        respond: { status: 200, body: code_climate_repository_json }
      )
    end

    context 'when missing test reports' do
      let(:repository_payload) do
        build :code_climate_repository_payload,
              latest_default_branch_snapshot_id: snapshot_id,
              latest_default_branch_test_report_id: nil
      end

      it 'does not set test coverage for the project metric' do
        update_project_code_climate_info
        expect(CodeClimateProjectMetric.first.test_coverage).to be_nil
      end
    end

    context 'when missing snapshots' do
      let(:repository_payload) do
        build :code_climate_repository_payload,
              latest_default_branch_snapshot_id: nil,
              latest_default_branch_test_report_id: test_report_id
      end

      it 'does not set any snapshot info for the project metric' do
        update_project_code_climate_info

        project_metric = CodeClimateProjectMetric.first
        expect(project_metric.code_climate_rate).to be_nil
        expect(project_metric.invalid_issues_count).to be_nil
        expect(project_metric.open_issues_count).to be_nil
        expect(project_metric.wont_fix_issues_count).to be_nil
        expect(project_metric.snapshot_time).to be_nil
      end
    end

    context 'when missing ratings' do
      let(:code_climate_snapshot_json) do
        build :code_climate_snapshot_payload,
              ratings: []
      end

      it 'does not set rate for the project metric' do
        update_project_code_climate_info
        expect(CodeClimateProjectMetric.first.code_climate_rate).to be_nil
      end
    end
  end
end
