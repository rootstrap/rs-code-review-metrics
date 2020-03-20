module EventBuilders
  class Review < EventBuilder
    ATTR_PAYLOAD_MAP = { body: 'body', state: 'state', opened_at: 'submitted_at' }.freeze

    def build
      review_data = @payload['review']
      Events::Review.find_or_create_by!(github_id: review_data['id']) do |review|
        review.owner = find_or_create_user(review_data['user'])
        review.pull_request = find_pull_request

        ATTR_PAYLOAD_MAP.each do |key, value|
          review.public_send("#{key}=", review_data.fetch(value))
        end
      end
    end
  end
end
