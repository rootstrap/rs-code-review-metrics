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

    context 'with a pull_request event' do
      subject { create :event_pull_request }

      it 'sets the occcured_at attribute from the payload data' do
        expect(subject.occurred_at).not_to be_nil
      end
    end

    context 'with a review event' do
      subject { create :event_review }

      it 'sets the occcured_at attribute from the payload data' do
        expect(subject.occurred_at).not_to be_nil
      end
    end

    context 'with a review_comment event' do
      subject { create :event_review_comment }

      it 'sets the occcured_at attribute from the payload data' do
        expect(subject.occurred_at).not_to be_nil
      end
    end

    context 'of an event not handled type' do
      subject { create :event_unhandled }

      it { should_not validate_presence_of(:occurred_at) }

      it 'sets the occcured_at to nil' do
        expect(subject.occurred_at).to be_nil
      end
    end
  end
end
