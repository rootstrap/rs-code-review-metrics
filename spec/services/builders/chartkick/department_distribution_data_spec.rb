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
      let(:values_in_seconds) { [108_00, 900_00, 144_000, 198_000, 226_800, 270_000] }

      let(:query) do
        { value_timestamp: range, name: metric_name }
      end

      subject do
        described_class.call(entity_id, query)
      end

      context 'when name is merge time' do
        let(:metric_name) { :merge_time }

        it_behaves_like 'merge time data distribution'
      end

      context 'when name is review turnaround' do
        let(:metric_name) { :review_turnaround }

        it_behaves_like 'review turnaround data distribution'
      end

      context 'when name is pull request size' do
        let(:metric_name) { :pull_request_size }
        let(:sizes_values) { [419, 915, 134, 12, 3333] }
        let(:expected_data) do
          [
            ['1-99', 1],
            ['100-199', 1],
            ['400-499', 1],
            ['900-999', 1],
            ['1000+', 1]
          ]
        end

        before do
          sizes_values.each do |size_value|
            pull_request = create(:pull_request, project: project, opened_at: Time.zone.now)
            create(:pull_request_size, value: size_value, pull_request: pull_request)
          end
        end

        it 'counts and classifies each pr size in the correct intervals and returns the data' do
          expect(subject.first[:data]).to eq(expected_data)
        end

        context 'when some pull requests have been created outside of the requested period' do
          before do
            old_timestamp = range.first.yesterday
            pull_request = create(:pull_request, project: project, opened_at: old_timestamp)
            create(:pull_request_size, value: 3, pull_request: pull_request)
          end

          it 'does not count them' do
            expect(subject.first[:data]).to eq(expected_data)
          end
        end
      end
    end
  end
end
