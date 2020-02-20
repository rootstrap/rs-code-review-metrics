require 'rails_helper'

RSpec.describe WebhookController, type: :controller do
  subject { post :handle, params: params }
  let(:headers) { { 'X-GitHub-Event': 'pull_request', 'X-Hub-Signature': '' } }
  let(:params) { { payload: (create :pull_request_payload).to_json } }

  before do
    request.headers.merge! headers
    allow_any_instance_of(WebhookController).to receive(:webhook_verified?).and_return(true)
  end

  it 'enqueues request handler job' do
    expect { subject }.to have_enqueued_job(RequestHandlerJob)
  end
end
