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
    context 'when creatin a review turnaround' do

      let(:rr) do
        create(:review_request, owner: vita, reviewer: santib, project: project, pull_request: pr)
      end

      let!(:review) do
        create(:review, owner: santib, project: project, pull_request: pr, review_request: rr)
      end

      let(:correct_value) do
        review.opened_at.to_i - rr.created_at.to_i
      end

      it 'returns the correct value for the review in seconds' do
        expect(described_class.call(rr).value).to eq(correct_value)
      end

      it 'returns the correct value for the review in seconds' do
        expect(described_class.call(rr)).to be_an(ReviewTurnaround)
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
  end
end
