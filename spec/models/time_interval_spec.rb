require 'rails_helper'

RSpec.describe TimeInterval do
  subject { described_class.new(starting_at: start_time, duration: duration) }

  let(:start_time) { Time.utc(2010, 1, 1, 0, 0, 0) }
  let(:duration) { 3.days }

  describe 'when comparing for equality with another TimeInterval' do
    let(:equal_time_interval) { TimeInterval.new(starting_at: start_time, duration: duration) }
    let(:overlapping_time_interval) do
      TimeInterval.new(starting_at: start_time - 1.day, duration: 3.days)
    end
    let(:included_time_interval) do
      TimeInterval.new(starting_at: start_time + 1.day, duration: 1.day)
    end
    let(:different_ending_at_time_interval) do
      TimeInterval.new(starting_at: start_time, duration: 2.days)
    end
    let(:different_starting_at_time_interval) do
      TimeInterval.new(starting_at: start_time - 1.day, duration: 4.days)
    end

    it 'returns true for an equal TimeInterval' do
      expect(subject).to eq(equal_time_interval)
    end

    it 'returns false for an overlapping TimeInterval' do
      expect(subject).not_to eq(overlapping_time_interval)
    end

    it 'returns false for an included TimeInterval' do
      expect(subject).not_to eq(included_time_interval)
    end

    it 'returns false for a TimeInterval with the same start time and a different end time' do
      expect(subject).not_to eq(different_ending_at_time_interval)
    end

    it 'returns false for a TimeInterval with the same end time and a different start time' do
      expect(subject).not_to eq(different_starting_at_time_interval)
    end

    it 'computes the same hash value than an equal TimeInterval' do
      expect(subject.hash).to eq(equal_time_interval.hash)
    end
  end

  describe 'when asking its duration' do
    it 'returns its duration' do
      expect(subject.duration).to eq(duration)
    end
  end

  describe 'when asking for a Time inclusion' do
    let(:before_time) { Time.utc(2009, 12, 31, 23, 59, 59) }
    let(:included_time) { Time.utc(2010, 1, 2, 20, 15, 1) }
    let(:closed_end_time) { Time.utc(2010, 1, 3, 23, 59, 59) }
    let(:opened_end_time) { Time.utc(2010, 1, 4, 0, 0, 0) }
    let(:after_time) { Time.utc(2010, 1, 4, 0, 0, 0) }

    it 'does not include a time before the TimeInterval' do
      expect(subject.includes?(before_time)).to be(false)
    end

    it 'includes the TimeInterval starting time' do
      expect(subject.includes?(start_time)).to be(true)
    end

    it 'includes a time in the TimeInterval' do
      expect(subject.includes?(included_time)).to be(true)
    end

    it 'includes the TimeInterval closed end_time' do
      expect(subject.includes?(closed_end_time)).to be(true)
    end

    it 'does not include the TimeInterval opened_end_time end_time' do
      expect(subject.includes?(opened_end_time)).to be(false)
    end

    it 'does not include a time after the TimeInterval' do
      expect(subject.includes?(after_time)).to be(false)
    end
  end

  describe 'when iterating over the daily intervals it includes' do
    let(:contiguous_time_interval) do
      TimeInterval.new(starting_at: start_time + duration, duration: duration)
    end

    it 'returns its contiguous time interval' do
      expect(subject.next).to eq(contiguous_time_interval)
    end
  end
end
