module Builders
  class ExternalPullRequest < BaseService
    def initialize(pull_request_data, external_project)
      @pull_request_data = pull_request_data
      @external_project = external_project
    end

    def call
      ::ExternalPullRequest.create!(
          github_id: @pull_request_data[:id],
          html_url: @pull_request_data[:html_url],
          body: @pull_request_data[:body],
          title: @pull_request_data[:title],
          owner_id: User.find_by!(login: @pull_request_data[:user][:login]).id,
          external_project_id: @external_project.id
      )
    end
  end
end
