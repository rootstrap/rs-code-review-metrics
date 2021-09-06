require 'rails_helper'

RSpec.shared_examples 'success rate' do
  before do
    values_in_seconds.each do |value|
      pull_request = create(:pull_request, repository: repository, merged_at: Time.zone.now)
      create(:merge_time, pull_request: pull_request, value: value)
    end
    query.merge!(name: :merge_time)
  end

  it 'returns an array with success_rate key' do
    expect(subject.first).to have_key(:success_rate)
  end

  it 'returns an array with filled value' do
    expect(subject.first[:success_rate]).to be_present
  end

  it 'returns rate value' do
    expect(subject.first[:success_rate][:rate]).to be_present
  end

  it 'returns number of items on the first 24hs' do
    expect(subject.first[:success_rate][:successful]).to be_present
  end

  it 'returns total of items' do
    expect(subject.first[:success_rate][:total]).to be_present
  end

  it 'returns metric settings' do
    expect(subject.first[:success_rate][:metric_detail]).to be_present
  end
end
