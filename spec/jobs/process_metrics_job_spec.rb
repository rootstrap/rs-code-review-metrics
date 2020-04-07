require 'rails_helper'

RSpec.describe ProcessMetricsJob, type: :job do
  subject { ProcessMetricsJob.new }

  it 'creates a Metrics::MetricsDefinitionProcessor object and calls :call it' do
    expect_any_instance_of(Processors::MetricsDefinition).to receive(:call).once

    subject.perform
  end
end
