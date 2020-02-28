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
#  project_id      :bigint           not null
#
# Indexes
#
#  index_events_on_handleable_type_and_handleable_id  (handleable_type,handleable_id)
#  index_events_on_project_id                         (project_id)
#

require 'rails_helper'

RSpec.describe Event, type: :model do
  subject { create :event_pull_request }

  context 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:data) }

    context 'of an event handled type' do
      it { should validate_presence_of(:handleable) }

      it 'should validate the name to match the event type' do
        subject = build(:event_pull_request, name: 'review')
        expect(subject).not_to be_valid
      end
    end
  end
end
