require 'rails_helper'

RSpec.describe Builders::Chartkick::DepartmentDistributionData do
  describe '.call' do
    context 'for a given entity' do
      let(:range) do
        Time.zone.today.beginning_of_week..Time.zone.today.end_of_week
      end

      let(:department) { Department.first }
      let(:entity_id) { department.id }
      let(:project) { create :project, language: department.languages.first }
      let(:values) { [2, 13, 25, 37, 49, 61, 73] }

      let(:query) do
        { value_timestamp: range }
      end

      subject do
        described_class.call(entity_id, query)
      end

      it 'returns an array' do
        expect(subject).to be_an(Array)
      end

      context 'when name is review turnaround' do
        before do
          values.each do |value|
            review_request = create :review_request, project: project
            create(:review_turnaround, review_request: review_request, value: value)
          end
          query.merge!(name: :review_turnaround)
        end

        it 'returns an array with name key' do
          expect(subject.first).to have_key(:name)
        end

        it 'returns an array with name data' do
          expect(subject.first).to have_key(:data)
        end

        it 'returns an array with filled value' do
          expect(subject.first[:data].empty?).to be false
        end
      end

      context 'when name is merge time' do
        before do
          values.each do |value|
            pull_request = create :pull_request, project: project
            create(:merge_time, pull_request: pull_request, value: value)
          end
          query.merge!(name: :merge_time)
        end

        it 'returns an array with name key' do
          expect(subject.first).to have_key(:name)
        end

        it 'returns an array with name data' do
          expect(subject.first).to have_key(:data)
        end

        it 'returns an array with filled value' do
          expect(subject.first[:data].empty?).to be false
        end
      end
    end
  end
end
