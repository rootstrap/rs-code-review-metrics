module Builders
  class ReviewOrCommentTurnaround < BaseService
    def initialize(review_request, pull_request, action)
      @review_request = review_request
      @pull_request = pull_request
      @action = action
    end

    def call
      build_review_turnaround
      build_completed_review_turnaround
    end

    private

    def build_review_turnaround
      return unless uniq_review_on_review_request?

      Builders::ReviewTurnaround.call(@review_request)
    end

    def build_completed_review_turnaround
      return unless second_review_with_different_users? && uniq_review_on_review_request?

      Builders::CompletedReviewTurnaround.call(@action)
    end

    def second_review_with_different_users?
      reviews_or_comments_different_users == 2
    end

    def reviews_or_comments_different_users
      count_reviews = @pull_request .reviews.distinct.pluck(:owner_id)
      count_comments = @pull_request .pull_request_comments.distinct.pluck(:owner_id)
      (count_reviews | count_comments).count
    end

    def uniq_review_on_review_request?
      reviews_or_comments_on_review_request.equal?(1)
    end

    def reviews_or_comments_on_review_request
      @review_request.reviews.count + @review_request.pull_request_comments.count
    end
  end
end
