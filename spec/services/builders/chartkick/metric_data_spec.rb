require 'rails_helper'

RSpec.describe Builders::Chartkick::MetricData do
  describe '.call' do
    let(:entities) { %w[repositories users_repository] }
    let(:metric_name) { 'review_turnaround' }
    let(:from) { 3.weeks.ago }
    let(:to) { Time.zone.now }
    let(:entity_id) { 1 }
    it 'calls weekly metrics for all the entities given' do
      entities.each do |entity|
        expect(Metrics::Group::Weekly)
          .to receive(:call).with(
            entity_id: entity_id, entity_name: entity, metric_name: metric_name, from: from, to: to
          ).once
      end
      described_class.call(entity_id, entities, metric_name, from, to)
    end
  end
end
