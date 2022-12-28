module Processors
  class ReviewTurnaroundPullRequestBackfiller < BaseService
    def call
      ReviewTurnaround.find_each do |review|
        review.update(pull_request: review.review_request.pull_request)
      end
    end
  end
end