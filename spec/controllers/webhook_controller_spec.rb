require 'rails_helper'

RSpec.describe WebhookController, type: :controller do
  subject { post :handle, params: params }
  let(:headers) { { 'X-GitHub-Event': 'pull_request', 'X-Hub-Signature': '' } }
  let(:params) { { payload: (create :pull_request_payload).to_json } }

  before do
    request.headers.merge! headers
    allow(OpenSSL::HMAC).to receive(:hexdigest).and_return(true)
    allow(ActiveSupport::SecurityUtils).to receive(:secure_compare).and_return(true)
  end

  it 'enqueues request handler job' do
    allow_any_instance_of(GithubService).to receive(:call).and_return(true)
    subject
  end
end
