module Processors
  module External
    class PullRequests < BaseService
      def initialize(username)
        @username = username
      end

      def call
        # #byebug
        external_pull_requests_events = CompanyMemberEventsDiscriminator.call(events)

        external_pull_requests_events.each do |pull_request_event|
          url_parser ||= PullRequestUrlParser.call(
            pull_request_event.dig(:payload, :pull_request, :html_url)
          )
          Builders::ExternalPullRequest::FromUrlParams.call(
            url_parser.repository_full_name,
            url_parser.pull_request_number
          )
        end
      end

      private

      def url_parser
        @url_parser ||= PullRequestUrlParser.call(params.dig('external_pull_request', 'html_url'))
      end

      def events
        @events ||= GithubClient::User.new(@username).pull_request_events
      end
    end
  end
end
