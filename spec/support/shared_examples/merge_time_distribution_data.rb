require 'rails_helper'

RSpec.shared_examples 'merge time data distribution' do
  it 'returns an array' do
    expect(subject).to be_an(Array)
  end

  context 'when name is merge time' do
    before do
      values.each do |value|
        pull_request = create(:pull_request, project: project)
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
      expect(subject.first[:data]).not_to be_empty
    end
  end
end
