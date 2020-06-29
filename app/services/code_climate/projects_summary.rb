module CodeClimate
  class ProjectsSummary
    attr_reader :invalid_issues_count_average,
                :wontfix_issues_count_average,
                :open_issues_count_average,
                :ratings,
                :projects_details

    def initialize(
      invalid_issues_count_average: nil,
      wontfix_issues_count_average: nil,
      open_issues_count_average: nil,
      ratings: {},
      projects_details: []
    )
      @invalid_issues_count_average = invalid_issues_count_average
      @wontfix_issues_count_average = wontfix_issues_count_average
      @open_issues_count_average = open_issues_count_average
      @ratings = ratings
      @projects_details = projects_details
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
