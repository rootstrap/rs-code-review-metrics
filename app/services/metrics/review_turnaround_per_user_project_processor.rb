module Metrics
  class ReviewTurnaroundPerUserProjectProcessor < MetricProcessor
    private

    def process
      retrieve_reviews.find_each.lazy.each do |review|
        entity = find_user_project(review.owner, review.pull_request.project)
        turnaround = (review.review_request.created_at.to_i - review.opened_at.to_i)

        find_or_create_metric(entity: entity)
          .update!(value: turnaround,
                   value_timestamp: time_interval.starting_at)
      end
    end

    def retrieve_reviews
      Queries::ReviewsTurnaroundPerUserProjectQuery.call(time_interval: time_interval)
    end

    def find_user_project(user, project)
      user.users_projects.detect { |user_project| user_project.project_id == project.id }
    end
  end
end
