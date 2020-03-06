require_relative '../support/validator_helper'

RSpec.describe EventNameValidator, type: :validator do
  subject { EventNameValidator.new }

  let(:event) do
    validation_target 'event' do |event|
      allow(event).to receive(:name).and_return(event_name)
      allow(event).to receive(:handleable_type_name).and_return(handleable_type_name)
    end
  end

  describe 'when the event.name matches the event.handleable_type_name' do
    let(:event_name) { 'pull_request' }
    let(:handleable_type_name) { 'pull_request' }

    it 'does not generate a validation error' do
      subject.validate(event)

      expect(event.errors).to be_empty
    end
  end

  describe 'when the event.name does not match the event.handleable_type_name' do
    let(:event_name) { 'pull_request' }
    let(:handleable_type_name) { 'review' }

    it 'generates a validation error' do
      subject.validate(event)

      expect(event.errors).to include(:name)
    end
  end
end
