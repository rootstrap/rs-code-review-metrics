module Processors
  module External
    class PullRequests < BaseService
      def initialize(username)
        @username = username
      end

      def call
        external_pull_requests_events = CompanyMemberEventsDiscriminator.call(events)

        external_pull_requests_events.each do |pull_request_event|
          Builders::ExternalPullRequest.call(pull_request_event, project(pull_request_event))
        end
      end

      private

      def events
        @events ||= GithubClient::User.new(@username).pull_request_events
      end

      def project(pull_request_event)
        Builders::ExternalProject.call(pull_request_event[:repo])
      end
    end
  end
end
