require 'rails_helper'

RSpec.describe Builders::MergeTime do
  describe '.call' do
    let(:project) { create(:project, language: Language.first) }
    let(:vita) { create(:user, login: 'santiagovidal') }

    context 'when pull request has different days for opening and merging in same week' do
      let(:monday) { Time.zone.now.beginning_of_week + 12.hours }
      let(:thursday) { (Time.zone.now.beginning_of_week + 3.days) + 12.hours }
      let(:seventy_two_hours_as_seconds) { 259200 }

      let(:pull_request) do
        create(:pull_request,
               owner: vita,
               project: project,
               opened_at:monday,
               merged_at: thursday
              )
      end

      it 'returns seventy two hours as seconds' do
        expect(described_class.call(pull_request).value).to eq(seventy_two_hours_as_seconds)
      end

      it 'returns merge time object' do
        expect(described_class.call(pull_request)).to be_an(MergeTime)
      end
    end

    context 'when there is a weekend in middle of the merging' do
      let(:friday) { (Time.zone.now.end_of_week - 2.days) - 6.hours + 1.second }
      let(:next_monday) { (Time.zone.now.beginning_of_week + 1.week) + 6.hours }
      let(:twelve_hours_as_seconds) { 432_00 }

      let(:pull_request) do
        create(:pull_request,
               owner: vita,
               project: project,
               opened_at:friday,
               merged_at: next_monday
              )
      end

      it 'does not count weekend seconds' do
        expect(described_class.call(pull_request).value).to eq(twelve_hours_as_seconds)
      end
    end

    context 'when the pull request was opened on friday and merged on sunday' do
      let(:friday) { (Time.zone.now.end_of_week - 2.days) - 6.hours + 1.second }
      let(:sunday) { Time.zone.now.end_of_week - 6.hours + 1.second}
      let(:six_hours_as_seconds) { 215_99 }

      let(:pull_request) do
        create(:pull_request,
               owner: vita,
               project: project,
               opened_at:friday,
               merged_at: sunday
              )
      end

      it 'calculates the value substracting all seconds of weekend days' do
        expect(described_class.call(pull_request).value).to eq(six_hours_as_seconds)
      end
    end

    context 'when pull request is opened on thursday and merged two weeks later on wednesday' do
      let(:wednesday_past_week) do
        ((Time.zone.now - 1.week).beginning_of_week + 2.days) + 12.hours
      end

      let(:thursday_next_week) do
        ((Time.zone.now + 1.week).end_of_week - 3.days)
      end

      let(:two_hundread_and_seventy_six_hours_seconds) { 993599 }

      let(:pull_request) do
        create(:pull_request,
               owner: vita,
               project: project,
               opened_at: wednesday_past_week,
               merged_at: thursday_next_week
              )
      end

      it 'calculates the value substracting all the seconds of weekend days' do
        expect(described_class.call(pull_request).value)
          .to eq(two_hundread_and_seventy_six_hours_seconds)
      end
    end
  end
end
