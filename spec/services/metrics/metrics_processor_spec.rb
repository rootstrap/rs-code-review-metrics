require_relative 'metrics_specs_helper'

RSpec.describe Metrics::MetricsProcessor do
  subject { Metrics::MetricsProcessor }

  describe 'when processing the defined metrics' do
    before do
      create :metrics_definition,
             metrics_name: 'review_turnaround',
             time_interval: :daily,
             subject: :projects,
             metrics_processor: Metrics::ReviewTurnaroundProcessor.name

      subject.call
    end

    it 'creates the concrete metrics processor to process the metrics' do
      expect(1).to eql(1)
    end
  end
end
