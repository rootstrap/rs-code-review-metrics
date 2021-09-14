module CodeClimate
  class RepositoriesSummary
    attr_reader :invalid_issues_count_average,
                :wont_fix_issues_count_average,
                :open_issues_count_average,
                :test_coverage_average,
                :ratings,
                :repositories_without_cc_count

    def initialize(
      invalid_issues_count_average: nil,
      wont_fix_issues_count_average: nil,
      open_issues_count_average: nil,
      test_coverage_average: nil,
      ratings: {},
      repositories_without_cc_count: 0
    )
      @invalid_issues_count_average = invalid_issues_count_average
      @wont_fix_issues_count_average = wont_fix_issues_count_average
      @open_issues_count_average = open_issues_count_average
      @test_coverage_average = test_coverage_average
      @ratings = ratings
      @repositories_without_cc_count = repositories_without_cc_count
    end

    def repositories_rated_with(letter)
      ratings&.fetch(letter.to_s, 0)
    end

    def each_repository_rate(&block)
      @ratings.each_pair(&block)
    end

    delegate :empty?, to: :@ratings
  end
end
