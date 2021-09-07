require 'rails_helper'

describe CodeClimate::UpdateProjectService do
  subject { CodeClimate::UpdateProjectService }

  let(:repo_id) { code_climate_repository_json['data'].first['id'] }
  let(:snapshot_id) { code_climate_snapshot_json['data']['id'] }
  let(:test_report_id) { code_climate_test_report_json['data']['id'] }

  let(:code_climate_repository_json) do
    build :code_climate_repository_by_slug_payload,
          latest_default_branch_snapshot_id: snapshot_id,
          latest_default_branch_test_report_id: test_report_id
  end
  let(:code_climate_snapshot_json) do
    build :code_climate_snapshot_payload,
          rate: 'A'
  end
  let(:code_climate_snapshot_issues_json) do
    build :code_climate_snapshot_issues_payload,
          status: %w[invalid wontfix invalid]
  end
  let(:code_climate_test_report_json) do
    build :code_climate_test_report_payload
  end

  let(:repository) { create :repository, name: 'rs-code-review-metrics' }
  let(:update_project_code_climate_info) { subject.call(repository) }

  context 'when the call to /repos' do
    context 'returns anything but 200' do
      before do
        stub_notification_webhook

        on_request_repository_by_slug(project_name: repository.name,
                                      respond: { status: 500 })
      end

      it 'does not update a CodeClimateProjectMetric record' do
        expect { update_project_code_climate_info }
          .not_to change { CodeClimateProjectMetric.count }
      end

      it 'notifies the error to slack channel' do
        expect(SlackService).to receive(:code_climate_error).with(repository, anything)

        update_project_code_climate_info
      end
    end

    context 'returns empty data' do
      before do
        stub_notification_webhook

        on_request_repository_by_slug(
          project_name: repository.name,
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
        stub_notification_webhook

        on_request_repository_by_slug(
          project_name: repository.name,
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

      it 'notifies the error to slack channel' do
        expect(SlackService).to receive(:code_climate_error).with(repository, anything)

        update_project_code_climate_info
      end
    end
  end

  context 'when the call to /repos/:id/snapshots/issues' do
    context 'returns anything but 200' do
      before do
        stub_notification_webhook

        on_request_repository_by_slug(
          project_name: repository.name,
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

      it 'notifies the error to slack channel' do
        expect(SlackService).to receive(:code_climate_error).with(repository, anything)

        update_project_code_climate_info
      end
    end
  end

  context 'when the call to /repos/:id/test_report/' do
    context 'returns anything but 200' do
      before do
        stub_notification_webhook

        on_request_repository_by_slug(
          project_name: repository.name,
          respond: { status: 200, body: code_climate_repository_json }
        )

        on_request_snapshot(repo_id: repo_id,
                            snapshot_id: snapshot_id,
                            respond: { status: 200, body: code_climate_snapshot_json })

        on_request_issues(repo_id: repo_id,
                          snapshot_id: snapshot_id,
                          respond: { status: 200, body: code_climate_snapshot_issues_json })

        on_request_test_report(repo_id: repo_id,
                               test_report_id: test_report_id,
                               respond: { status: 500 })
      end

      it 'does not update a CodeClimateProjectMetric record' do
        expect { update_project_code_climate_info }
          .not_to change { CodeClimateProjectMetric.count }
      end

      it 'notifies the error to slack channel' do
        expect(SlackService).to receive(:code_climate_error).with(repository, anything)

        update_project_code_climate_info
      end
    end
  end
end
