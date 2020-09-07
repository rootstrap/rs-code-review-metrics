module Processors
  module External
    class PullRequests < BaseService
      def initialize(repository_data, username)
        @repository_data = repository_data
        @username = username
      end

      def call
        rs_member_pull_requests = pull_requests_data.select do |pull_request_data|
          pull_request_data[:user][:login] == @username
        end

        rs_member_pull_requests.each do |pull_request|
          Builders::ExternalPullRequest.call(pull_request, project)
        end
      end

      private

      def pull_requests_data
        @pull_requests_data ||= GithubClient::Repository.new(project).pull_requests
      end

      def project
        @project ||= Builders::ExternalProject.call(@repository_data)
      end
    end
  end
end
