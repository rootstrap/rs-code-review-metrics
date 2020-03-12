# == Schema Information
#
# Table name: events
#
#  id              :bigint           not null, primary key
#  data            :jsonb
#  handleable_type :string
#  name            :string
#  occurred_at     :datetime
#  type            :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  handleable_id   :bigint
#  project_id      :bigint           not null
#
# Indexes
#
#  index_events_on_handleable_type_and_handleable_id  (handleable_type,handleable_id)
#  index_events_on_occurred_at                        (occurred_at)
#  index_events_on_project_id                         (project_id)
#

require 'rails_helper'

RSpec.describe Event, type: :model do
  subject { create :event_pull_request }

  context 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:data) }

    context 'with an event of a handled type' do
      it 'validates the name to match the event type' do
        subject = build(:event_pull_request, name: 'review')
        expect(subject).not_to be_valid
      end
    end

    context 'with a pull_request event' do
      subject { create :event_pull_request }
      let(:pull_request_event_with_invalid_name) { build(:event_pull_request, name: 'review') }

      it { should validate_presence_of(:handleable) }
      it { should validate_presence_of(:occurred_at) }

      it 'validates the event name to match the event type' do
        expect(pull_request_event_with_invalid_name).not_to be_valid
      end

      it 'sets the occcured_at attribute from the payload data' do
        expect(subject.occurred_at).not_to be_nil
      end
    end

    context 'with a review event' do
      subject { create :event_review }
      let(:review_event_with_invalid_name) { build(:event_review, name: 'pull_request') }

      it { should validate_presence_of(:handleable) }
      it { should validate_presence_of(:occurred_at) }

      it 'validates the event name to match the event type' do
        expect(review_event_with_invalid_name).not_to be_valid
      end

      it 'sets the occcured_at attribute from the payload data' do
        expect(subject.occurred_at).not_to be_nil
      end
    end

    context 'with a review_comment event' do
      subject { create :event_review_comment }
      let(:review_comment_event_with_invalid_name) do
        build(:event_review_comment, name: 'pull_request')
      end

      it { should validate_presence_of(:handleable) }
      it { should validate_presence_of(:occurred_at) }

      it 'validates the event name to match the event type' do
        expect(review_comment_event_with_invalid_name).not_to be_valid
      end

      it 'sets the occcured_at attribute from the payload data' do
        expect(subject.occurred_at).not_to be_nil
      end
    end

    context 'of an event not handled type' do
      subject { create :event, data: { unhandled_event: {} } }

      it { should_not validate_presence_of(:occurred_at) }

      it 'sets the occcured_at to nil' do
        expect(subject.occurred_at).to be_nil
      end
    end
  end
end
