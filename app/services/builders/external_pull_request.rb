module Builders
  class ExternalPullRequest < BaseService
    def initialize(pull_request_data)
      @pull_request_data = pull_request_data
    end

    def call
      pull_request = ::ExternalPullRequest
                     .find_or_initialize_by(
                       github_id: pull_request_data[:id]
                     ) do |ext_pull_request|
        ext_pull_request.html_url = pull_request_data[:html_url]
        ext_pull_request.body = pull_request_data[:body]
        ext_pull_request.title = pull_request_data[:title]
        ext_pull_request.opened_at = pull_request_data[:created_at]
        ext_pull_request.owner = owner
        ext_pull_request.external_project = external_project
      end
      pull_request.state = assign_state
      pull_request.save!
      pull_request
    end

    private

    attr_reader :pull_request_data

    def assign_state
      return 'merged' if pull_request_data[:merged]

      pull_request_data[:state]
    end

    def external_project
      Builders::ExternalProject.call(pull_request_data.dig(:base, :repo))
    end

    def owner
      User.find_by!(login: pull_request_data.dig(:user, :login))
    end
  end
end
