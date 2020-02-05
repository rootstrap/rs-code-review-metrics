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
  subject { build :event }

  context 'validations' do
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
    let(:project) { create :project }
    before do
      subject.name = 'comment'
      subject.data = { pull_request: { id: 1000 } }
    end

    it 'creates a event' do
      expect {
        subject.resolve
      }.to change(Event, :count).by(1)
    end
  end
end
