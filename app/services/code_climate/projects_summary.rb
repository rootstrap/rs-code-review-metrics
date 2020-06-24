module CodeClimate
  class ProjectsSummary
    attr_reader :invalid_issues_count_average,
                :wontfix_issues_count_average,
                :open_issues_count_average,
                :ratings

    def initialize(
      invalid_issues_count_average: nil,
      wontfix_issues_count_average: nil,
      open_issues_count_average: nil,
      ratings: {}
    )
      @invalid_issues_count_average = invalid_issues_count_average
      @wontfix_issues_count_average = wontfix_issues_count_average
      @open_issues_count_average = open_issues_count_average
      @ratings = ratings
    end

    def projects_rated_with(letter)
      ratings&.fetch(letter.to_s, 0)
    end

    def each_project_rate(&block)
      ratings.each_pair(&block)
    end

    delegate :empty?, to: :ratings
  end
end
