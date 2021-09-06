require 'rails_helper'

RSpec.describe 'Admin::ExternalPullRequests' do
  include Devise::Test::IntegrationHelpers

  let!(:admin) { create(:admin_user) }

  before { sign_in admin }

  describe '#create' do
    let(:project_owner) { 'rootstrap' }
    let(:project_name) { 'rs-code-review-metrics' }
    let(:project_full_name) { "#{project_owner}/#{project_name}" }
    let(:pull_request_number) { 111 }
    let(:url) { "https://github.com/#{project_full_name}/pull/#{pull_request_number}" }
    let(:project) { ExternalProject.new(full_name: project_full_name) }
    let(:pull_request) do
      ExternalPullRequest.new(number: pull_request_number, external_project: project)
    end
    let(:repository_payload) do
      build(:repository_payload, name: project_name, owner: { login: project_owner })
    end
    let(:pull_request_payload) do
      build(
        :github_api_client_pull_request_payload,
        number: pull_request_number,
        base_repo: repository_payload
      )
    end
    let(:params) do
      {
        'external_pull_request': { 'html_url': url }
      }
    end

    before { stub_get_pull_request(pull_request, pull_request_payload) }

    it 'creates a new external pull request' do
      expect {
        post admin_external_pull_requests_path, params: params
      }.to change { ExternalPullRequest.count }.by(1)
    end

    it 'the created pull request matches the attributes requested' do
      post admin_external_pull_requests_path, params: params

      created_pull_request = ExternalPullRequest.last
      expect(created_pull_request.number).to eq pull_request_number
      expect(created_pull_request.repository.full_name).to eq project_full_name
    end
  end
end
