module Builders
  module Events
    class PullRequestComment < Builders::Events::Base
      ATTR_PAYLOAD_MAP = { body: 'body', opened_at: 'created_at' }.freeze

      def build
        comment_data = @payload['comment']
        ::Events::PullRequestComment.find_or_create_by!(github_id: comment_data['id']) do |prc|
          assign_attrs(prc, comment_data)

          ATTR_PAYLOAD_MAP.each do |key, value|
            prc.public_send("#{key}=", comment_data.fetch(value))
          end
        end
      end

      def assign_attrs(prc, comment_data)
        repository = Builders::Repository.call(@payload['repository'])
        prc.owner = find_or_create_user(comment_data['user'])
        prc.pull_request = find_issue_pull_request(repository.id)
        prc.review_request = find_last_review_request(prc.pull_request, prc.owner.id)
      end
    end
  end
end
