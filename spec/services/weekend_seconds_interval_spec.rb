require 'rails_helper'

RSpec.describe WeekendSecondsInterval do
  context 'when there is a weekend in middle of start and end date' do
    let(:friday) { Time.zone.now.end_of_week - 2.days }
    let(:next_monday) { Time.zone.now.end_of_week + 1.day }
    let(:forty_eight_hours_as_seconds) { 172_800 }

    it 'returns 48 hours as seconds' do
      expect(described_class.call(start_date: friday, end_date: next_monday))
        .to eq(forty_eight_hours_as_seconds)
    end
  end

  context 'when the end_date is weekend' do
    let(:friday) { Time.zone.now.end_of_week - 2.days - 6.hours + 1.second }
    let(:sunday) { Time.zone.now.end_of_week - 6.hours + 1.second }
    let(:forty_two_hours_as_seconds) { 151_201 }
    it 'returns 48 hours as seconds' do
      expect(described_class.call(start_date: friday, end_date: sunday))
        .to eq(forty_two_hours_as_seconds)
    end
  end
end
