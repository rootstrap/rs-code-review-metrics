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
      ratings: nil
    )
      @invalid_issues_count_average = invalid_issues_count_average
      @wontfix_issues_count_average = wontfix_issues_count_average
      @open_issues_count_average = open_issues_count_average
      @ratings = ratings
    end

    def projects_rated_with(letter)
      ratings&.fetch(letter.to_s, 0)
    end

    def rating_names
      ratings.keys
    end
  end
end
