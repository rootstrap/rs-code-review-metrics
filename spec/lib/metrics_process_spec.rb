require 'rails_helper'
require 'rake'

RSpec.describe 'running the rake task metrics:process' do
  before do
    load_rake_metrics
  end

  let(:load_rake_metrics) do
    Rake.application.rake_require 'tasks/metrics'
    Rake::Task.define_task(:environment)
  end

  let(:rake_process_metrics) do
    Rake.application.invoke_task 'metrics:process'
  end

  it 'creates a ProcessMetricsJob and invokes it' do
      expect_any_instance_of(ProcessMetricsJob).to receive(:perform).once

      rake_process_metrics
  end
end
