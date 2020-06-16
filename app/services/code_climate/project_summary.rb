module CodeClimate
  class ProjectSummary
    attr_reader :rate, :invalid_issues_count, :open_issues_count, :wont_fix_issues_count

    def initialize(rate:, invalid_issues_count:, open_issues_count:, wont_fix_issues_count:)
      @rate = rate
      @invalid_issues_count = invalid_issues_count
      @open_issues_count = open_issues_count
      @wont_fix_issues_count = wont_fix_issues_count
    end
  end
end
