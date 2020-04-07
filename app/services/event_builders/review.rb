module EventBuilders
  class Review < EventBuilder
    ATTR_PAYLOAD_MAP = { body: 'body', state: 'state', opened_at: 'submitted_at' }.freeze

    def build
      review_data = @payload['review']
      Events::Review.find_or_create_by!(github_id: review_data['id']) do |review|
        assign_attrs(review, review_data)

        ATTR_PAYLOAD_MAP.each do |key, value|
          review.public_send("#{key}=", review_data.fetch(value))
        end
      end
    end

    def assign_attrs(review, review_data)
      review.owner = find_or_create_user(review_data['user'])
      review.pull_request = find_pull_request

      owner = review.owner
      pull_request = review.pull_request
      review.review_request = find_or_create_review_request(pull_request, owner.id)
      owner.projects << pull_request.project
    end
  end
end
