require 'rails_helper'

describe CodeClimate::Link do
  let(:subject) { described_class.call(repository) }
  let(:code_climate_repository_json) { create(:code_climate_repository_by_slug_payload) }
  let(:new_cc_repo_id) { code_climate_repository_json['data'].first['id'] }

  context 'when repository has Code Climate' do
    let(:code_climate_repository_metric) do
      create(:code_climate_repository_metric, cc_repository_id: local_cc_repo_id)
    end
    let(:repository) do
      create(:repository, code_climate_repository_metric: code_climate_repository_metric)
    end

    context "when repository has OUTDATED code climate repository metric's cc_repository_id" do
      let(:local_cc_repo_id) { 'outdated_id' }

      before do
        on_request_repository_by_slug(
          repository_name: repository.name,
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
          repository.code_climate_repository_metric.reload.cc_repository_id
        }.from(local_cc_repo_id)
          .to(new_cc_repo_id)
      end
    end

    context "when repository has code climate repository metric's cc_repository_id UP TO DATE" do
      let(:local_cc_repo_id) { new_cc_repo_id }

      before do
        on_request_repository_by_slug(
          repository_name: repository.name,
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
          repository.code_climate_repository_metric.reload.cc_repository_id
        }
      end
    end
  end

  context 'when repository does not have Code Climate' do
    let(:repository) { create(:repository) }

    it 'does not call CodeClimate API' do
      subject
      expect(WebMock).not_to have_requested(:get, %r{https://api.codeclimate.com/v1/.*})
    end

    it 'does not change the repository' do
      expect { subject }.not_to change { repository }
    end

    it 'does not change code climate repository metric count' do
      expect { subject }.not_to change { CodeClimateRepositoryMetric.count }
    end
  end
end
