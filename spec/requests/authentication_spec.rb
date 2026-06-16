require 'rails_helper'

describe 'Endpoint authentication', :unauthenticated, type: :request do
  describe 'a protected browser-facing endpoint' do
    it 'redirects anonymous visitors to the login page' do
      get root_path

      expect(response).to redirect_to(new_admin_user_session_path)
    end

    it 'grants access once an admin is signed in' do
      sign_in create(:admin_user)

      get root_path

      expect(response).to have_http_status(:ok)
    end
  end

  describe 'the GitHub webhook endpoint' do
    before do
      allow(OpenSSL::HMAC).to receive(:hexdigest).and_return(true)
      allow(ActiveSupport::SecurityUtils).to receive(:secure_compare).and_return(true)
      allow_any_instance_of(GithubService).to receive(:call).and_return(true)
    end

    it 'stays public and is not redirected to the login page' do
      post '/github_event_handler',
           params: { payload: { action: 'opened' }.to_json },
           headers: { 'X-GitHub-Event' => 'pull_request' }

      expect(response).to have_http_status(:ok)
      expect(response).not_to redirect_to(new_admin_user_session_path)
    end
  end
end
