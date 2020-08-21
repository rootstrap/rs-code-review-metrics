module CodeClimate
  class ProjectSummary
    attr_reader :rate, :invalid_issues_count, :open_issues_count,
                :wont_fix_issues_count, :snapshot_time, :name,
                :repo_id, :test_coverage

    def initialize(rate:, issues:, snapshot_time:,
                   test_coverage: nil, name: nil, repository_id: nil)
      @rate = rate
      @invalid_issues_count = issues[:invalid_issues_count]
      @open_issues_count = issues[:open_issues_count]
      @wont_fix_issues_count = issues[:wont_fix_issues_count]
      @snapshot_time = snapshot_time
      @test_coverage = test_coverage
      @name = name
      @repo_id = repository_id
    end
  end
end
