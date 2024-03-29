module Builders
  module Events
    class Base < BaseService
      def initialize(payload:)
        @payload = payload
      end

      def call
        build
      end

      private

      def find_pull_request
        ::Events::PullRequest.find_by!(github_id: @payload['pull_request']['id'])
      end

      def find_issue_pull_request(repository_id)
        ::Events::PullRequest.find_by!(number: @payload['issue']['number'],
                                       repository_id: repository_id)
      end

      def find_last_review_request(pull_request, reviewer_id)
        review_request = pull_request.review_requests.where(reviewer_id: reviewer_id).last
        return review_request unless review_request.nil?

        raise Reviews::NoReviewRequestError
      end

      def find_or_create_user_repository(repository_id, user_id)
        UsersRepository.find_or_create_by!(repository_id: repository_id, user_id: user_id)
      end
    end
  end
end
