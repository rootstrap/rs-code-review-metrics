module Queries
  class ReviewsTurnaroundPerProjectQuery
    attr_reader :time_interval

    def initialize(time_interval:)
      @time_interval = time_interval
    end

    def last_review_created_at
      Events::Review.order(:created_at).pluck(:created_at).last
    end

    def each(&block)
      query.each do |project_value|
        block.call(
          project_id: project_value.first,
          turnaround_as_seconds: turnaround_as_seconds(project_value.second)
        )
      end
    end

    def query
      Project
        .joins(pull_requests: [:reviews])
        .where('reviews.id IN (?)', oldest_review_in_pr_query)
        .group(:id)
        .average(
          'EXTRACT(EPOCH FROM reviews.opened_at) ' \
          '- ' \
          'EXTRACT(EPOCH FROM pull_requests.opened_at)'
        )
    end

    def oldest_review_in_pr_query
      query_string = '? < reviews.created_at AND ' \
            '? < reviews.created_at AND ' \
            'reviews.opened_at = (select min(r.opened_at) ' \
                                  'from reviews r ' \
                                  'where r.pull_request_id = reviews.pull_request_id)'

      Events::Review
        .select(:id)
        .joins(:pull_request)
        .where(query_string, starting_at, ending_at)
        .distinct
    end

    def starting_at
      @time_interval.starting_at
    end

    def ending_at
      @time_interval.ending_at
    end

    def turnaround_as_seconds(query_turnaround)
      query_turnaround.seconds
    end
  end
end
