require 'rails_helper'

RSpec.describe Builders::ReviewTurnaround do
  describe '.call' do
    let(:project) { create(:project, language: Language.first) }
    let(:vita) { create(:user, login: 'santiagovidal') }
    let(:santib) { create(:user, login: 'santib') }
    let(:pr) { create(:pull_request, owner: vita, project: project) }

    before do
      allow_any_instance_of(Events::Review).to receive(:build_review_turnaround)
    end

    context 'when review request and review has different in same week' do
      let(:monday) { Time.zone.now.beginning_of_week + 12.hours }
      let(:thursday) { (Time.zone.now.beginning_of_week + 3.days) + 12.hours }

      let(:review_request) do
        create(:review_request,
               owner: vita,
               reviewer: santib,
               project: project,
               pull_request: pr,
               created_at: monday
              )
      end

      let!(:review) do
        create(:review,
               owner: santib,
               project: project,
               pull_request: pr,
               review_request: review_request,
               opened_at: thursday
              )
      end

      let(:seventy_two_hours_as_seconds) { 259200 }

      it 'returns the correct value for the review in seconds' do
        expect(described_class.call(review_request).value).to eq(seventy_two_hours_as_seconds)
      end

      it 'returns a review turnaround object' do
        expect(described_class.call(review_request)).to be_an(ReviewTurnaround)
      end
    end

    context 'when there is a weekend between the review request and the review' do
      let(:friday) { (Time.zone.now.end_of_week - 2.days) - 6.hours + 1.second }
      let(:next_monday) { (Time.zone.now.beginning_of_week + 1.week) + 6.hours }
      let(:twelve_hours_as_seconds) { 432_00 }

      let(:review_request) do
        create(:review_request,
               owner: vita,
               reviewer: santib,
               project: project,
               pull_request: pr,
               created_at: friday)
      end

      let!(:review) do
        create(:review,
               owner: santib,
               project: project,
               pull_request: pr,
               review_request: review_request,
               opened_at: next_monday)
      end

      it 'does not count those days' do
        expect(described_class.call(review_request).value).to eq(twelve_hours_as_seconds)
      end
    end

    context 'when the review request is on friday and review on sunday' do
      let(:friday) { (Time.zone.now.end_of_week - 2.days) - 6.hours + 1.second }
      let(:sunday) { Time.zone.now.end_of_week - 6.hours + 1.second}
      let(:six_hours_as_seconds) { 215_99 }

      let(:review_request) do
        create(:review_request,
               owner: vita,
               reviewer: santib,
               project: project,
               pull_request: pr,
               created_at: friday)
      end

      let!(:review) do
        create(:review,
               owner: santib,
               project: project,
               pull_request: pr,
               review_request: review_request,
               opened_at: sunday)
      end

      it 'calculates the value substracting all the second of weekend days' do
        expect(described_class.call(review_request).value).to eq(six_hours_as_seconds)
      end
    end

    context 'when the review request is on thursday and review is two weeks later on wednesday' do
      let(:wednesday_past_week) do
        ((Time.zone.now - 1.week).beginning_of_week + 2.days) + 12.hours
      end

      let(:thursday_next_week) do
        ((Time.zone.now + 1.week).end_of_week - 3.days)
      end

      let(:review_request) do
        create(:review_request,
               owner: vita,
               reviewer: santib,
               project: project,
               pull_request: pr,
               created_at: wednesday_past_week)
      end

      let!(:review) do
        create(:review,
               owner: santib,
               project: project,
               pull_request: pr,
               review_request: review_request,
               opened_at: thursday_next_week)
      end

      let(:two_hundread_and_seventy_six_hours_seconds) { 993599 }

      it 'calculates the value substracting all the second of weekend days' do
        expect(described_class.call(review_request).value)
          .to eq(two_hundread_and_seventy_six_hours_seconds)
      end
    end
  end
end
