require 'rails_helper'

RSpec.shared_examples 'metric job' do
  it 'calls review turnaround proccesor' do
    expect_any_instance_of(Processors::ReviewTurnaround).to receive(:call).once

    described_class.perform_now
  end
end
