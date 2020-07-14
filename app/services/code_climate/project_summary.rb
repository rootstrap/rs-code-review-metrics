module CodeClimate
  class ProjectSummary
    attr_reader :rate, :invalid_issues_count, :open_issues_count,
                :wont_fix_issues_count, :snapshot_time, :name

    def initialize(rate:, invalid_issues_count:, open_issues_count:,
                   wont_fix_issues_count:, snapshot_time:, name:)

      @rate = rate
      @invalid_issues_count = invalid_issues_count
      @open_issues_count = open_issues_count
      @wont_fix_issues_count = wont_fix_issues_count
      @snapshot_time = snapshot_time
      @name = name
    end
  end
end
