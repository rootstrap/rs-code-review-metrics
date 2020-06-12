require_relative '../code_climate_spec_helper'

describe CodeClimate::UpdateProjectService do
  subject { CodeClimate::UpdateProjectService }

  before do
    on_request_repository(project_name: project.name,
                          respond: { status: 200, body: code_climate_repository_json })

    on_request_snapshot(repo_id: repo_id,
                        snapshot_id: snapshot_id,
                        respond: { status: 200, body: code_climate_snapshot_json })

    on_request_issues(repo_id: repo_id,
                      snapshot_id: snapshot_id,
                      respond: { status: 200, body: code_climate_snapshot_issues_json })
  end

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

  context 'when the call to /repos' do
    context 'returns anything but 200' do
      before do
        on_request_repository(project_name: project.name,
                              respond: { status: 500 })
      end

      it 'does not update a CodeClimateProjectMetric record' do
        expect { update_project_code_climate_info }.not_to change { CodeClimateProjectMetric.count }
      end
    end

    context 'returns an unexpected json structure' do
      before do
        on_request_repository(project_name: project.name,
                              respond: { status: 200, body: '' })
      end

      it 'does not update a CodeClimateProjectMetric record' do
        expect { update_project_code_climate_info }.not_to change { CodeClimateProjectMetric.count }
      end
    end
  end

  context 'when the call to /repos/:id/snapshots/' do
    context 'returns anything but 200' do
      before do
        on_request_snapshot(repo_id: repo_id,
                            snapshot_id: snapshot_id,
                            respond: { status: 500 })
      end

      it 'does not update a CodeClimateProjectMetric record' do
        expect { update_project_code_climate_info }.not_to change { CodeClimateProjectMetric.count }
      end
    end

    context 'returns an unexpected json structure' do
      before do
        on_request_snapshot(repo_id: repo_id,
                            snapshot_id: snapshot_id,
                            respond: { status: 500 })
      end

      it 'does not update a CodeClimateProjectMetric record' do
        expect { update_project_code_climate_info }.not_to change { CodeClimateProjectMetric.count }
      end
    end
  end

  context 'when the call to /repos/:id/snapshots/issues' do
    context 'returns anything but 200' do
      before do
        on_request_issues(repo_id: repo_id,
                          snapshot_id: snapshot_id,
                          respond: { status: 500 })
      end

      it 'does not update a CodeClimateProjectMetric record' do
        expect { update_project_code_climate_info }.not_to change { CodeClimateProjectMetric.count }
      end
    end

    context 'returns an unexpected json structure' do
      before do
        on_request_issues(repo_id: repo_id,
                          snapshot_id: snapshot_id,
                          respond: { status: 500 })
      end

      it 'does not update a CodeClimateProjectMetric record' do
        expect { update_project_code_climate_info }.not_to change { CodeClimateProjectMetric.count }
      end
    end
  end
end
