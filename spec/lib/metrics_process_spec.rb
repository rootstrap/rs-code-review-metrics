require 'rails_helper'
require 'rake'

RSpec.describe 'running the rake task metrics:process' do
  before do
    Rake.application.rake_require 'tasks/metrics'
    Rake::Task.define_task(:environment)
  end

  it 'creates a ProcessMetricsJob and invokes it' do
    expect {
      Rake.application.invoke_task 'metrics:process'
    } .to satisfy proc {
      expect_any_instance_of(ProcessMetricsJob).to receive(:perform).once
    }
  end
end
