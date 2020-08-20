module CodeClimateApiMocker
  CODE_CLIMATE_API_URL = ENV['CODE_CLIMATE_API_URL']

  def on_request_repository_by_slug(project_name:, respond:)
    stub_request(:get, "#{CODE_CLIMATE_API_URL}/repos?github_slug=rootstrap/#{project_name}")
      .to_return(status: respond[:status], body: JSON.generate(respond[:body]))
  end

  def on_request_repository_by_repo_id(repo_id:, respond:)
    stub_request(:get, "#{CODE_CLIMATE_API_URL}/repos/#{repo_id}")
      .to_return(status: respond[:status], body: JSON.generate(respond[:body]))
  end

  def on_request_snapshot(repo_id:, snapshot_id:, respond:)
    stub_request(:get, "#{CODE_CLIMATE_API_URL}/repos/#{repo_id}/snapshots/#{snapshot_id}")
      .to_return(status: respond[:status], body: JSON.generate(respond[:body]))
  end

  def on_request_issues(repo_id:, snapshot_id:, respond:)
    stub_request(:get, "#{CODE_CLIMATE_API_URL}/repos/#{repo_id}/snapshots/#{snapshot_id}/issues")
      .to_return(status: respond[:status], body: JSON.generate(respond[:body]))
  end

  def on_request_test_report(repo_id:, test_report_id:, respond:)
    stub_request(:get, "#{CODE_CLIMATE_API_URL}/repos/#{repo_id}/test_reports/#{test_report_id}")
      .to_return(status: respond[:status], body: JSON.generate(respond[:body]))
  end
end
