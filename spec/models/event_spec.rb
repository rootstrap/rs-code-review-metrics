# == Schema Information
#
# Table name: events
#
#  id              :bigint           not null, primary key
#  data            :jsonb
#  handleable_type :string
#  name            :string
#  type            :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  handleable_id   :bigint
#
# Indexes
#
#  index_events_on_handleable_type_and_handleable_id  (handleable_type,handleable_id)
#

require 'rails_helper'

RSpec.describe Event, type: :model do
  context 'validations' do
    subject { build :event }

    it 'is not valid without data' do
      subject.data = nil
      expect(subject).to_not be_valid
    end

    it 'is not valid without name' do
      subject.name = nil
      expect(subject).to_not be_valid
    end
  end

  describe '#resolve' do
    it 'enqueues job' do
      expect {
        described_class.resolve(event: '')
      }.to have_enqueued_job(EventJob)
    end

    it 'calls event class' do
      expect(Events::PullRequest).to receive(:resolve).with(event: 'pull_request')
      described_class.resolve(event: 'pull_request')
    end
  end
end
