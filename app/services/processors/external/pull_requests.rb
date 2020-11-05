module Processors
  module External
    class PullRequests < BaseService
      def initialize(username)
        @username = username
      end

      def call
        external_pull_requests_events = CompanyMemberEventsDiscriminator.call(events)

        external_pull_requests_events.each do |pull_request_event|
          Builders::ExternalPullRequest.call(pull_request_event.dig(:payload, :pull_request))
        end
      end

      private

      def events
        @events ||= GithubClient::User.new(@username).pull_request_events
      end
    end
  end
end
