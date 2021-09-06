module Builders
  class ReviewRequest < BaseService
    def initialize(pull_request, payload)
      @pull_request = pull_request
      @payload = payload
    end

    def call
      generate
    end

    private

    def generate
      @pull_request.review_requests.create(column_map).persisted?
    end

    def column_map
      {
        reviewer: find_or_create_user(@payload['requested_reviewer']),
        owner: find_or_create_user(@payload['pull_request']['user']),
        repository: Builders::Project.call(@payload['repository']),
        state: 'active'
      }
    end
  end
end
