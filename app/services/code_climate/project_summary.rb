module CodeClimate
  class ProjectSummary
    attr_reader :rate, :invalid_issues_count, :open_issues_count,
                :wont_fix_issues_count, :snapshot_time, :name

    def initialize(metric:, project_name:)
      @rate = metric.code_climate_rate
      @invalid_issues_count = metric.invalid_issues_count
      @open_issues_count = metric.open_issues_count
      @wont_fix_issues_count = metric.wont_fix_issues_count
      @snapshot_time = metric.snapshot_time
      @name = project_name
    end
  end
end
