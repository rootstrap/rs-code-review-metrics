require 'rails_helper'

RSpec.describe Builders::Chartkick::ProjectData do
  describe '.call' do
    context 'for a given entity' do
      let(:range) do
        Time.zone.today.beginning_of_week..Time.zone.today.end_of_week
      end

      let(:entity_id) { Project.last.id }

      let(:query) do
        { interval: :weekly, value_timestamp: range }
      end

      let(:user_project) { create(:users_project) }

      subject do
        described_class.call(entity_id, query)
      end

      before do
        create(:weekly_metric,
               ownable: user_project,
               value_timestamp: Time.zone.today.beginning_of_week)
      end

      it 'returns an array' do
        expect(subject).to be_an(Array)
      end

      it 'returns an array with name key' do
        expect(subject.first).to have_key(:name)
      end

      it 'returns an array with name data' do
        expect(subject.first).to have_key(:data)
      end
    end
  end
end
