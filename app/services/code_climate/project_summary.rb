module CodeClimate
  class ProjectSummary
    attr_reader :rate, :invalid_issues_count, :open_issues_count,
                :wont_fix_issues_count, :snapshot_time, :name

    def initialize(rate:, issues:, snapshot_time:, name: nil)
      @rate = rate
      @invalid_issues_count = issues[:invalid_issues_count]
      @open_issues_count = issues[:open_issues_count]
      @wont_fix_issues_count = issues[:wont_fix_issues_count]
      @snapshot_time = snapshot_time
      @name = name
    end
  end
end
