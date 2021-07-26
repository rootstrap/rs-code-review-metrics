require 'rails_helper'

RSpec.describe Builders::ReviewTurnaround do
  describe '.call' do
    let(:project) { create(:project, language: Language.first) }
    let(:vita) { create(:user, login: 'santiagovidal') }
    let(:santib) { create(:user, login: 'santib') }
    let(:pr) { create(:pull_request, owner: vita, project: project) }

    before do
      allow_any_instance_of(Builders::ReviewOrCommentTurnaround)
        .to receive(:build_review_turnaround)
    end

    shared_context 'has different in same week' do
      let(:monday) { Time.zone.now.beginning_of_week + 12.hours }
      let(:thursday) { (Time.zone.now.beginning_of_week + 3.days) + 12.hours }
      let(:seventy_two_hours_as_seconds) { 259_200 }

      let(:review_request) do
        create(:review_request,
               owner: vita,
               reviewer: santib,
               project: project,
               pull_request: pr,
               created_at: monday)
      end
    end

    shared_examples 'for same week' do
      it 'returns the correct value for the action in seconds' do
        expect(described_class.call(review_request).value).to eq(seventy_two_hours_as_seconds)
      end

      it 'returns a review turnaround object' do
        expect(described_class.call(review_request)).to be_an(ReviewTurnaround)
      end
    end

    context 'when review request and review' do
      include_context 'has different in same week'

      let!(:action) do
        create(:review,
               owner: santib,
               project: project,
               pull_request: pr,
               review_request: review_request,
               opened_at: thursday)
      end

      it_behaves_like 'for same week'
    end

    context 'when review request and comment' do
      include_context 'has different in same week'

      let!(:action) do
        create(:pull_request_comment,
               owner: santib,
               pull_request: pr,
               review_request: review_request,
               opened_at: thursday)
      end

      it_behaves_like 'for same week'
    end

    shared_context 'have a weekend inbetween' do
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
    end

    shared_examples 'for different weeks' do
      it 'does not count those days' do
        expect(described_class.call(review_request).value).to eq(twelve_hours_as_seconds)
      end
    end

    context 'when the review request and the review' do
      include_context 'have a weekend inbetween'

      let!(:action) do
        create(:review,
               owner: santib,
               project: project,
               pull_request: pr,
               review_request: review_request,
               opened_at: next_monday)
      end

      it_behaves_like 'for different weeks'
    end

    context 'when the review request and the comment' do
      include_context 'have a weekend inbetween'

      let!(:action) do
        create(:pull_request_comment,
               owner: santib,
               pull_request: pr,
               review_request: review_request,
               opened_at: next_monday)
      end

      it_behaves_like 'for different weeks'
    end

    shared_context 'on friday and on sunday respectively' do
      let(:friday) { (Time.zone.now.end_of_week - 2.days) - 6.hours + 1.second }
      let(:sunday) { Time.zone.now.end_of_week - 6.hours + 1.second }
      let(:six_hours_as_seconds) { 215_99 }

      let(:review_request) do
        create(:review_request,
               owner: vita,
               reviewer: santib,
               project: project,
               pull_request: pr,
               created_at: friday)
      end
    end

    shared_examples 'for friday and sunday' do
      it 'calculates the value substracting all the second of weekend days' do
        expect(described_class.call(review_request).value).to eq(six_hours_as_seconds)
      end
    end

    context 'when the review request and review are' do
      include_context 'on friday and on sunday respectively'
      let!(:action) do
        create(:review,
               owner: santib,
               project: project,
               pull_request: pr,
               review_request: review_request,
               opened_at: sunday)
      end

      it_behaves_like 'for friday and sunday'
    end

    context 'when the review request and comment are' do
      include_context 'on friday and on sunday respectively'
      let!(:action) do
        create(:pull_request_comment,
               owner: santib,
               pull_request: pr,
               review_request: review_request,
               opened_at: sunday)
      end

      it_behaves_like 'for friday and sunday'
    end

    shared_context 'on thursday and two weeks later on wednesday respectively' do
      let(:wednesday_past_week) do
        ((Time.zone.now - 1.week).beginning_of_week + 2.days) + 12.hours
      end

      let(:thursday_next_week) do
        ((Time.zone.now + 1.week).end_of_week - 3.days)
      end

      let(:two_hundread_and_seventy_six_hours_seconds) { 993_599 }

      let(:review_request) do
        create(:review_request,
               owner: vita,
               reviewer: santib,
               project: project,
               pull_request: pr,
               created_at: wednesday_past_week)
      end
    end

    shared_examples 'for thursday and two weeks later on wednesday' do
      it 'calculates the value substracting all the second of weekend days' do
        expect(described_class.call(review_request).value)
          .to eq(two_hundread_and_seventy_six_hours_seconds)
      end
    end

    context 'when the review request and review are' do
      include_context 'on thursday and two weeks later on wednesday respectively'

      let!(:action) do
        create(:review,
               owner: santib,
               project: project,
               pull_request: pr,
               review_request: review_request,
               opened_at: thursday_next_week)
      end

      it_behaves_like 'for thursday and two weeks later on wednesday'
    end

    context 'when the review request and comment are' do
      include_context 'on thursday and two weeks later on wednesday respectively'

      let!(:action) do
        create(:pull_request_comment,
               owner: santib,
               pull_request: pr,
               review_request: review_request,
               opened_at: thursday_next_week)
      end

      it_behaves_like 'for thursday and two weeks later on wednesday'
    end

    context 'when comment was opened before a review' do
      include_context 'has different in same week'

      let!(:comment) do
        create(:pull_request_comment,
               owner: santib,
               pull_request: pr,
               review_request: review_request,
               opened_at: thursday)
      end

      let!(:review) do
        create(:review,
               owner: santib,
               project: project,
               pull_request: pr,
               review_request: review_request,
               opened_at: thursday + 1.hour)
      end

      it_behaves_like 'for same week'
    end

    context 'when review was opened before a comment' do
      include_context 'has different in same week'

      let!(:review) do
        create(:review,
               owner: santib,
               project: project,
               pull_request: pr,
               review_request: review_request,
               opened_at: thursday)
      end

      let!(:comment) do
        create(:pull_request_comment,
               owner: santib,
               pull_request: pr,
               review_request: review_request,
               opened_at: thursday + 1.hour)
      end

      it_behaves_like 'for same week'
    end
  end
end
