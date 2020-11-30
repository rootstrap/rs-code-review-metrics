module CodeClimate
  class ProjectsSummary
    attr_reader :invalid_issues_count_average,
                :wont_fix_issues_count_average,
                :open_issues_count_average,
                :ratings,
                :projects_without_cc_count

    def initialize(
      invalid_issues_count_average: nil,
      wont_fix_issues_count_average: nil,
      open_issues_count_average: nil,
      ratings: {},
      projects_without_cc_count: 0
    )
      @invalid_issues_count_average = invalid_issues_count_average
      @wont_fix_issues_count_average = wont_fix_issues_count_average
      @open_issues_count_average = open_issues_count_average
      @ratings = ratings
      @projects_without_cc_count = projects_without_cc_count
    end

    def projects_rated_with(letter)
      ratings&.fetch(letter.to_s, 0)
    end

    def each_project_rate(&block)
      @ratings.each_pair(&block)
    end

    delegate :empty?, to: :@ratings
  end
end
