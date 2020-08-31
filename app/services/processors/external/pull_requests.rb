module Processors
  module External
    class PullRequests < BaseService
      def initialize(project, username)
        @project = project
        @username = username
      end

      def call
        rs_member_pull_requests = pull_requests_data.select do |pull_request_data|
          pull_request_data[:user][:login] == @username
        end
        return if rs_member_pull_requests.empty?

        @project.save!
        rs_member_pull_requests.each do |pull_request|
          Builders::ExternalPullRequest.call(pull_request, @project)
        end
      end

      private

      def pull_requests_data
        @pull_requests_data ||= GithubClient::Repository.new(@project).pull_requests
      end
    end
  end
end
