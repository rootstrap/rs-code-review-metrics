require 'rails_helper'

RSpec.describe Builders::Chartkick::UsersProjectData do
  describe '.call' do
    context 'for a given entity' do
      let(:range) do
        Time.zone.today.beginning_of_week..Time.zone.today.end_of_week
      end

      let(:entity_id) { Project.last.id }

      let(:query) do
        { name: 'ReviewTurnaround', interval: :weekly, value_timestamp: range }
      end

      let(:review_request) { create(:review_request) }
      let!(:completed_review_turnaround) do
        create(:completed_review_turnaround, review_request: review_request)
      end
      let!(:users_project) do
        create(:users_project, project_id: review_request.project_id,
                               user_id: review_request.owner_id)
      end

      subject do
        described_class.call(entity_id, query)
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
