require 'rails_helper'

RSpec.shared_examples 'average' do
  before do
    values_for_average.each do |value|
      pull_request = create(
        :pull_request,
        repository: repository,
        size: value,
        opened_at: Time.zone.now,
        merged_at: Time.zone.now
      )
      create(:merge_time, pull_request: pull_request, value: value)
    end
    query.merge!(name: metric_name)
  end

  it 'returns an array with interval_metrics key' do
    expect(subject.first).to have_key(:interval_metrics)
  end

  it 'returns an array with filled value' do
    expect(subject.first[:interval_metrics][:avg_number]).to eq(average_value)
  end

  it 'returns total number of records' do
    expect(subject.first[:interval_metrics][:total]).to eq(values_for_average.count)
  end

  context 'when there is an ignored user' do
    let(:ignored_user) { create(:user, login: 'ignored_user') }
    let!(:setting) { create(:setting, key: 'ignored_users', value: ignored_user.login) }
    let!(:ignored_user_pull_request) do
      create(
        :pull_request,
        repository: repository,
        size: 100_000,
        opened_at: Time.zone.now,
        merged_at: Time.zone.now,
        owner: ignored_user
      )
    end

    it 'does not include ignored user in the total' do
      expect(subject.first[:interval_metrics][:total]).to eq(values_for_average.count)
    end
  end

  context 'when there are no records' do
    let(:values_for_average) { [] }

    it 'returns nil for interval_metrics' do
      expect(subject.first[:interval_metrics]).to be_nil
    end
  end
end
