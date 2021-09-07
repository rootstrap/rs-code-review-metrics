require 'rails_helper'

RSpec.shared_examples 'pull request size data distribution' do
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
      create(:pull_request, repository: repository, opened_at: Time.zone.now, size: size_value)
    end
  end

  it 'counts and classifies each pr size in the correct intervals and returns the data' do
    expect(subject.first[:data]).to eq(expected_data)
  end

  context 'when some pull requests have been created outside of the requested period' do
    before do
      old_timestamp = range.first.yesterday
      create(:pull_request, repository: repository, opened_at: old_timestamp, size: 3)
    end

    it 'does not count them' do
      expect(subject.first[:data]).to eq(expected_data)
    end
  end
end
