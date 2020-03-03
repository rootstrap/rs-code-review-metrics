require 'rails_helper'

RSpec.describe TimeInterval do
  subject { TimeInterval.new(starting_at: start_time, duration: duration) }

  let(:start_time) { Time.utc(2010, 1, 1, 0, 0, 0) }
  let(:duration) { 3.days }

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
end
