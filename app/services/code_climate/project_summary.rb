module CodeClimate
  class ProjectSummary
    attr_reader :rate, :invalid_issues_count, :open_issues_count,
                :wont_fix_issues_count, :snapshot_time

    def initialize(rate:, invalid_issues_count:, open_issues_count:,
                   wont_fix_issues_count:, snapshot_time:)

      @rate = rate
      @invalid_issues_count = invalid_issues_count
      @open_issues_count = open_issues_count
      @wont_fix_issues_count = wont_fix_issues_count
      @snapshot_time = snapshot_time
    end
  end
end
