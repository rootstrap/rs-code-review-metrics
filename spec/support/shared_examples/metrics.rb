require 'rails_helper'

RSpec.shared_examples 'available metrics data' do
  it 'returns two metrics' do
    metrics = subject
    expect(metrics.count).to eq 2
  end

  it 'returns metric ownable id' do
    metrics = subject
    metrics.each do |metric|
      expect(metric.ownable_id).to be_present
    end
  end

  it 'returns metric ownable type' do
    metrics = subject
    metrics.each do |metric|
      expect(metric.ownable_type).to eq entity_type
    end
  end

  it 'returns metric value timestamp' do
    metrics = subject
    metrics.each do |metric|
      expect(metric.value_timestamp).to be_present
    end
  end

  it 'returns metric name' do
    metrics = subject
    metrics.each do |metric|
      expect(metric.name).to eq metric_name
    end
  end

  it 'returns average value for each entity' do
    metrics = subject
    metrics.each do |metric|
      expect(metric.value.seconds).to eq 2.hours
    end
  end
end

RSpec.shared_examples 'unavailable metrics data' do
  context 'when no data is available' do
    it 'returns no metrics' do
      expect(subject).to be_empty
    end
  end
end
