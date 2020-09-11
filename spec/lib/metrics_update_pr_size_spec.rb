require 'rails_helper'
require 'rake'

RSpec.describe 'running the rake task metrics:update_pr_size' do
  before do
    load_rake_metrics
  end

  let(:load_rake_metrics) do
    Rake.application.rake_require 'tasks/metrics'
    Rake::Task.define_task(:environment)
  end

  let(:rake_update_pr_size) do
    Rake.application.invoke_task 'metrics:update_pr_size'
  end

  it 'runs the PullRequestSizeUpdaterJob' do
    expect(PullRequestSizeUpdaterJob).to receive(:perform_now)

    rake_update_pr_size
  end
end
