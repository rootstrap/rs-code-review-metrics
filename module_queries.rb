module Queries
  class ReviewsTurnaroundPerProjectQuery
    attr_reader :time_interval

    def initialize(time_interval:)
      @time_interval = time_interval
    end

    def last_processed_review
      Events::Review
        .where(created_at: @time_interval.starting_at..@time_interval.ending_at)
        .order(created_at: :desc)
        .limit(1)
        .first
    end

    def each(&block)
      query.compact.each do |project_value|
        block.call(
          project_id: project_value.first,
          turnaround_as_seconds: project_value.last.seconds
        )
      end
    end

    def query
      Project.eager_load(pull_requests: :reviews)
             .where(reviews: { created_at: @time_interval.starting_at..@time_interval.ending_at })
             .each do |project|
        return project.pull_requests.map do |pull_request|
          next if pull_request.reviews.empty?

          [project.id, (pull_request.reviews.minimum(:opened_at).to_i - pull_request.opened_at.to_i)]
        end
      end
    end
  end
end
