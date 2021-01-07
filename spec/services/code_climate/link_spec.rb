require 'rails_helper'

describe CodeClimate::Link do
  let(:subject) { described_class.call(project) }
  let(:code_climate_repository_json) { create(:code_climate_repository_by_slug_payload) }
  let(:new_cc_repo_id) { code_climate_repository_json['data'].first['id'] }

  context 'when project has Code Climate' do
    let(:code_climate_project_metric) do
      create(:code_climate_project_metric, cc_repository_id: local_cc_repo_id)
    end
    let(:project) { create(:project, code_climate_project_metric: code_climate_project_metric) }

    context "when project has OUTDATED code climate project metric's cc_repository_id" do
      let(:local_cc_repo_id) { 'outdated_id' }

      before do
        on_request_repository_by_slug(
          project_name: project.name,
          respond: { status: 200, body: code_climate_repository_json }
        )
      end

      it 'calls CodeClimate API' do
        subject
        expect(WebMock).to have_requested(:get, %r{https://api.codeclimate.com/v1/.*})
      end

      it 'updates cc_repository_id' do
        expect {
          subject
        }.to change {
          project.code_climate_project_metric.reload.cc_repository_id
        }.from(local_cc_repo_id)
          .to(new_cc_repo_id)
      end
    end

    context "when project has code climate project metric's cc_repository_id UP TO DATE" do
      let(:local_cc_repo_id) { new_cc_repo_id }

      before do
        on_request_repository_by_slug(
          project_name: project.name,
          respond: { status: 200, body: code_climate_repository_json }
        )
      end

      it 'calls CodeClimate API' do
        subject
        expect(WebMock).to have_requested(:get, %r{https://api.codeclimate.com/v1/.*})
      end

      it 'does not update cc_repository_id' do
        expect {
          subject
        }.not_to change {
          project.code_climate_project_metric.reload.cc_repository_id
        }
      end
    end
  end

  context 'when project does not have Code Climate' do
    let(:project) { create(:project) }

    it 'does not call CodeClimate API' do
      subject
      expect(WebMock).not_to have_requested(:get, %r{https://api.codeclimate.com/v1/.*})
    end

    it 'does not change the project' do
      expect { subject }.not_to change { project }
    end

    it 'does not change code climate project metric count' do
      expect { subject }.not_to change { CodeClimateProjectMetric.count }
    end
  end
end
