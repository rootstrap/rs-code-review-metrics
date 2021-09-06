require 'rails_helper'

RSpec.shared_examples 'merge time data distribution' do
  it 'returns an array' do
    expect(subject).to be_an(Array)
  end

  context 'when name is merge time' do
    before do
      values_in_seconds.each do |value|
        pull_request = create(:pull_request, repository: repository, merged_at: Time.zone.now)
        create(:merge_time, pull_request: pull_request, value: value)
      end
      query.merge!(name: :merge_time)
    end

    it 'returns an array with size of number of values' do
      expect(subject.first[:data]).to have_exactly(6).items
    end

    it 'returns an array with one value matched in every position' do
      subject.first[:data].each do |data_array|
        expect(data_array.second).to eq(1)
      end
    end

    it 'returns an array with name key' do
      expect(subject.first).to have_key(:name)
    end

    it 'returns an array with name data' do
      expect(subject.first).to have_key(:data)
    end

    it 'returns an array with filled value' do
      expect(subject.first[:data]).not_to be_empty
    end

    context 'when there are pull requests merged outside of the requested period' do
      before do
        old_timestamp = range.first.yesterday
        pull_request = create(:pull_request, repository: repository, merged_at: old_timestamp)
        create(:merge_time, pull_request: pull_request, value: 90_000)
      end

      it 'does not count them' do
        subject.first[:data].each do |data_array|
          expect(data_array.second).to eq(1)
        end
      end
    end
  end
end
