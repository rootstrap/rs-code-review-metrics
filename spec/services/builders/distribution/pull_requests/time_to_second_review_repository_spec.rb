require 'rails_helper'

RSpec.describe Builders::Distribution::PullRequests::TimeToSecondReviewRepository do
  describe '.call' do
    let(:user1) { create(:user, login: 'user1') }
    let(:user2) { create(:user, login: 'user2') }
    let(:user3) { create(:user, login: 'user3') }

    let(:repository_ok) { create(:repository) }
    let(:repository_not_ok) { create(:repository) }

    let!(:first_pull_request) do
      create(:pull_request,
             repository: repository_ok,
             html_url: 'test_pr_url_one',
             opened_at: 6.hours.ago)
    end

    let!(:second_pull_request) do
      create(:pull_request,
             repository: repository_not_ok,
             html_url: 'test_pr_url_two',
             opened_at: 14.hours.ago)
    end

    let!(:third_pull_request) do
      create(:pull_request,
             repository: repository_ok,
             html_url: 'test_pr_url_three',
             opened_at: 26.hours.ago)
    end
    let(:prs) { [first_pull_request, second_pull_request, third_pull_request] }

    before do
      prs.each do |pr|
        create(:review_request, owner: user1, reviewer: user2, repository: pr.repository,
                                pull_request: pr)
        create(:review, owner: user2, repository: pr.repository, pull_request: pr,
                        review_request: ReviewRequest.last)
        create(:review_request, owner: user1, reviewer: user3, repository: pr.repository,
                                pull_request: pr)
        create(:review, owner: user3, repository: pr.repository, pull_request: pr,
                        review_request: ReviewRequest.last)
      end
    end

    context 'with correct params' do
      subject do
        described_class.call(
          repository_name: repository_ok.name,
          from: 4
        )
      end

      it 'returns data for 1-12 hours' do
        expect(subject).to have_key('1-12')
      end

      it 'returns data for 24-36 hours' do
        expect(subject).to have_key('24-36')
      end

      it 'does not return any data for 12-24 hours' do
        expect(subject).not_to have_key('12-24')
      end
    end

    context 'when pull request has html_url attribute nil' do
      let!(:pr) do
        create(:pull_request,
               repository: repository_ok,
               html_url: nil,
               owner: user1,
               opened_at: 40.hours.ago)
      end

      before do
        create(:review_request, owner: user1, reviewer: user2, repository: pr.repository,
                                pull_request: pr)
        create(:review, owner: user2, repository: pr.repository, pull_request: pr,
                        review_request: ReviewRequest.last)
        create(:review_request, owner: user1, reviewer: user3, repository: pr.repository,
                                pull_request: pr)
        create(:review, owner: user3, repository: pr.repository, pull_request: pr,
                        review_request: ReviewRequest.last)
      end

      subject do
        described_class.call(
          repository_name: repository_ok.name,
          from: 4
        )
      end

      it 'does not add the pull request to the data' do
        expect(subject).not_to have_key('36-48')
      end
    end
  end
end
