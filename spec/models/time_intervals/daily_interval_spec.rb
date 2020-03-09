require 'rails_helper'

RSpec.describe TimeIntervals::DailyInterval do
  let(:start_time) { Time.utc(2010, 1, 1, 0, 0, 0) }
  let(:end_time) { start_time + 3.days }

  describe 'when iterating over the daily intervals starting within itself' do
    let(:duration) { 1.day }
    let(:iterated_intervals) { [] }
    let(:expected_intervals) do
      [
        TimeInterval.new(starting_at: start_time, duration: duration),
        TimeInterval.new(starting_at: start_time + 1.day, duration: duration),
        TimeInterval.new(starting_at: start_time + 2.days, duration: duration)
      ]
    end

    it 'iterates each daily interval starting in the subject interval' do
      expect {
        TimeIntervals::DailyInterval.each_from(start_time, up_to: end_time) do |daily_interval|
          iterated_intervals << daily_interval
        end
      }.to change { iterated_intervals }.from([]).to(expected_intervals)
    end
  end

  describe 'when asking its contiguous time_interval' do
    let(:time_interval) do
      TimeInterval.new(starting_at: start_time, duration: 3.days)
    end
    let(:expected_time_interval) do
      TimeInterval.new(starting_at: start_time + 3.days, duration: 1.day)
    end

    it 'returns the daily TimeInterval next to the given TimeInterval' do
      expect(TimeIntervals::DailyInterval.next_to(time_interval)).to eq(expected_time_interval)
    end
  end
end
