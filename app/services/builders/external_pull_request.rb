module Builders
  class ExternalPullRequest < BaseService
    def initialize(pull_request_event_data, external_project)
      @pull_request_event_data = pull_request_event_data
      @external_project = external_project
    end

    def call
      pull_request_payload = @pull_request_event_data.dig(:payload, :pull_request)

      pull_request = ::ExternalPullRequest
                     .find_or_initialize_by(
                       github_id: pull_request_payload[:id]
                     ) do |ext_pull_request|
        ext_pull_request.html_url = pull_request_payload[:html_url]
        ext_pull_request.body = pull_request_payload[:body]
        ext_pull_request.title = pull_request_payload[:title]
        ext_pull_request.opened_at = pull_request_payload[:created_at]
        ext_pull_request.owner_id = User.find_by!(
          login: @pull_request_event_data.dig(:actor, :login)
        ).id
        ext_pull_request.external_project_id = @external_project.id
      end
      pull_request.state = assign_state(pull_request_payload)
      pull_request.save!
      pull_request
    end

    private

    def assign_state(pull_request_payload)
      return 'merged' if pull_request_payload[:merged]

      pull_request_payload[:state]
    end
  end
end
