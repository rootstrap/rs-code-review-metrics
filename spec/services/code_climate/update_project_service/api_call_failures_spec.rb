require 'rails_helper'

describe CodeClimate::UpdateProjectService do
  subject { CodeClimate::UpdateProjectService }

  let(:repo_id) { code_climate_repository_json['data'].first['id'] }
  let(:snapshot_id) { code_climate_snapshot_json['data']['id'] }

  let(:code_climate_repository_json) do
    build :code_climate_repository_by_slug_payload,
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
        on_request_repository_by_slug(project_name: project.name,
                                      respond: { status: 500 })
      end

      it 'does not update a CodeClimateProjectMetric record' do
        expect { update_project_code_climate_info }
          .not_to change { CodeClimateProjectMetric.count }
      end

      it 'notifies the error to exception hunter' do
        expect(ExceptionHunter).to receive(:track).with(kind_of(Faraday::Error))

        update_project_code_climate_info
      end
    end

    context 'returns empty data' do
      before do
        on_request_repository_by_slug(
          project_name: project.name,
          respond: { status: 200, body: code_climate_repository_json }
        )
      end

      let(:code_climate_repository_json) do
        build(:code_climate_repository_by_slug_payload, data: [])
      end

      it 'does not update a CodeClimateProjectMetric record' do
        expect { update_project_code_climate_info }
          .not_to change { CodeClimateProjectMetric.count }
      end
    end
  end

  context 'when the call to /repos/:id/snapshots/' do
    context 'returns anything but 200' do
      before do
        on_request_repository_by_slug(
          project_name: project.name,
          respond: { status: 200, body: code_climate_repository_json }
        )

        on_request_snapshot(repo_id: repo_id,
                            snapshot_id: snapshot_id,
                            respond: { status: 500 })
      end

      it 'does not update a CodeClimateProjectMetric record' do
        expect { update_project_code_climate_info }
          .not_to change { CodeClimateProjectMetric.count }
      end

      it 'notifies the error to exception hunter' do
        expect(ExceptionHunter).to receive(:track).with(kind_of(Faraday::Error))

        update_project_code_climate_info
      end
    end
  end

  context 'when the call to /repos/:id/snapshots/issues' do
    context 'returns anything but 200' do
      before do
        on_request_repository_by_slug(
          project_name: project.name,
          respond: { status: 200, body: code_climate_repository_json }
        )

        on_request_snapshot(repo_id: repo_id,
                            snapshot_id: snapshot_id,
                            respond: { status: 200, body: code_climate_snapshot_json })

        on_request_issues(repo_id: repo_id,
                          snapshot_id: snapshot_id,
                          respond: { status: 500 })
      end

      it 'does not update a CodeClimateProjectMetric record' do
        expect { update_project_code_climate_info }
          .not_to change { CodeClimateProjectMetric.count }
      end

      it 'notifies the error to exception hunter' do
        expect(ExceptionHunter).to receive(:track).with(kind_of(Faraday::Error))

        update_project_code_climate_info
      end
    end
  end
end
