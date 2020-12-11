require 'rails_helper'

RSpec.shared_examples 'review turnaround data distribution' do
  context 'when name is review turnaround' do
    before do
      values_in_seconds.each do |value|
        review_request = create :review_request, project: project
        create(:completed_review_turnaround, review_request: review_request, value: value)
      end
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
