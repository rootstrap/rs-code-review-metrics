module Builders
  class ExternalPullRequest < BaseService
    def initialize(pull_request_event_data, external_project)
      @pull_request_event_data = pull_request_event_data
      @external_project = external_project
    end

    def call
      pull_request_payload = @pull_request_event_data.dig(:payload, :pull_request)

      ::ExternalPullRequest
        .find_or_create_by!(github_id: pull_request_payload[:id]) do |pull_request|
        pull_request.html_url = pull_request_payload[:html_url]
        pull_request.body = pull_request_payload[:body]
        pull_request.title = pull_request_payload[:title]
        pull_request.opened_at = pull_request_payload[:created_at]
        pull_request.owner_id = User.find_by!(
          login: @pull_request_event_data.dig(:actor, :login)
        ).id
        pull_request.external_project_id = @external_project.id
      end
    end
  end
end
