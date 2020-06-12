require 'rails_helper'

module CodeClimateSpecHelper
  def base_url
    'https://api.codeclimate.com/v1'
  end

  def on_request_repository(project_name:, respond:)
    stub_request(:get, "#{base_url}/repos?github_slug=rootstrap/#{project_name}")
      .to_return(status: respond[:status], body: JSON.generate(respond[:body]))
  end

  def on_request_snapshot(repo_id:, snapshot_id:, respond:)
    stub_request(:get, "#{base_url}/repos/#{repo_id}/snapshots/#{snapshot_id}")
      .to_return(status: respond[:status], body: JSON.generate(respond[:body]))
  end

  def on_request_issues(repo_id:, snapshot_id:, respond:)
    stub_request(:get, "#{base_url}/repos/#{repo_id}/snapshots/#{snapshot_id}/issues")
      .to_return(status: respond[:status], body: JSON.generate(respond[:body]))
  end
end

RSpec.configure do |c|
  c.include CodeClimateSpecHelper
end
