require 'rails_helper'

RSpec.describe TimeIntervals::DailyInterval do
  let(:start_time) { Time.utc(2010, 1, 1, 15, 10, 30) }
  let(:end_time) { Time.utc(2010, 1, 3, 1, 0, 10) }

  let(:begining_of_day) { Time.utc(2010, 1, 1, 0, 0, 0) }

  describe 'when iterating over the daily intervals starting within itself' do
    let(:iterated_intervals) { [] }
    let(:expected_intervals) do
      [
        TimeIntervals::DailyInterval.containing(begining_of_day),
        TimeIntervals::DailyInterval.containing(begining_of_day + 1.day),
        TimeIntervals::DailyInterval.containing(begining_of_day + 2.days)
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
      TimeIntervals::DailyInterval.containing(start_time)
    end
    let(:expected_time_interval) do
      TimeIntervals::DailyInterval.containing(begining_of_day + 1.day)
    end

    it 'returns the daily TimeInterval next to the given TimeInterval' do
      expect(TimeIntervals::DailyInterval.next_to(time_interval)).to eq(expected_time_interval)
    end
  end
end
