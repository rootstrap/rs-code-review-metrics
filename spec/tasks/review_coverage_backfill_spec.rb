require 'rails_helper'
require 'rake'

RSpec.describe 'review_coverage:backfill' do
  subject { rake['review_coverage:backfill'].invoke }

  let(:rake) { Rake::Application.new }
  let!(:merged_pr) { create(:pull_request, merged_at: Time.current) }
  let(:github_client) { instance_double(GithubClient::PullRequest) }

  before do
    Rake.application = rake
    Rake::Task.define_task(:environment)
    load 'lib/tasks/review_coverage_backfill.rake'

    allow(GithubClient::PullRequest).to receive(:new).with(merged_pr).and_return(github_client)
    allow(github_client).to receive(:files).and_return(["file1.rb"])
    allow(github_client).to receive(:comments).and_return([{ path: "file1.rb" }])
  end

  it 'processes merged pull requests' do
    expect { subject }.to change { ReviewCoverage.count }.by(1)
  end

  context 'when there is a not merged pull request' do
    let!(:unmerged_pr) { create(:pull_request, merged_at: nil) }

    it 'does not process unmerged pull requests' do
      expect { subject }.to change { ReviewCoverage.count }.by(1)
    end
  end
end 