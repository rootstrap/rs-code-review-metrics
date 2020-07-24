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
      let(:values) { [108_00, 900_00, 144_000, 198_000, 226_800, 270_000] }

      let(:query) do
        { value_timestamp: range }
      end

      subject do
        described_class.call(entity_id, query)
      end

      it_behaves_like 'merge time data distribution'

      context 'when name is review turnaround' do
        before do
          values.each do |value|
            review_request = create :review_request, project: project
            create(:completed_review_turnaround, review_request: review_request, value: value)
          end
          query.merge!(name: :review_turnaround)
        end

        it 'returns an array with name key' do
          expect(subject.first).to have_key(:name)
        end

        it 'returns an array with size of number of values' do
          expect(subject.first[:data]).to have_exactly(6).items
        end

        it 'returns an array with one value matched in every position' do
          subject.first[:data].each do |data_array|
            expect(data_array.second).to eq(1)
          end
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
