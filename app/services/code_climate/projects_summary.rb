module CodeClimate
  class ProjectsSummary
    attr_reader :invalid_issues_count_average,
                :wontfix_issues_count_average,
                :open_issues_count_average,
                :ratings

    def initialize(
      invalid_issues_count_average:,
      wontfix_issues_count_average:,
      open_issues_count_average:,
      ratings:
    )
      @invalid_issues_count_average = invalid_issues_count_average
      @wontfix_issues_count_average = wontfix_issues_count_average
      @open_issues_count_average = open_issues_count_average
      @ratings = ratings
    end

    def projects_rated_with(letter)
      ratings.fetch(letter.to_s, 0)
    end
  end
end
