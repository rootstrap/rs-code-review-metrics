require 'rails_helper'

RSpec.describe Builders::ReviewTurnaround do
  describe '.call' do
    let(:project) { create(:project, language: Language.first) }
    let(:vita) { create(:user, login: 'santiagovidal') }
    let(:santib) { create(:user, login: 'santib') }
    let(:pr) { create(:pull_request, owner: vita, project: project) }

    let(:rr) do
      create(:review_request, owner: vita, reviewer: santib, project: project, pull_request: pr)
    end

    before(:all) { Events::Review.skip_callback(:create, :after, :build_review_turnaround) }

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
end
