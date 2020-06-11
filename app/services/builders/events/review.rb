module Builders
  module Events
    class Review < Builders::Events::Base
      ATTR_PAYLOAD_MAP = { body: 'body', state: 'state', opened_at: 'submitted_at' }.freeze

      def build
        review_data = @payload['review']
        ::Events::Review.find_or_create_by!(github_id: review_data['id']) do |review|
          assign_attrs(review, review_data)
          find_or_create_user_project(review.pull_request.project.id, review.owner.id)

          ATTR_PAYLOAD_MAP.each do |key, value|
            review.public_send("#{key}=", review_data.fetch(value))
          end
        end
      end

      def assign_attrs(review, review_data)
        review.owner = find_or_create_user(review_data['user'])
        review.pull_request = find_pull_request
        review.review_request = find_last_review_request(review.pull_request, review.owner.id)
        review.project = Builders::Project.call(@payload['repository'])
      end
    end
  end
end
