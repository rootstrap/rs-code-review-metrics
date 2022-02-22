require 'rails_helper'

RSpec.describe 'Time To Second Review PRs' do
  let(:user1) { create(:user, login: 'user1') }
  let(:user2) { create(:user, login: 'user2') }
  let(:user3) { create(:user, login: 'user3') }
  let(:from) { 4.weeks.ago }
  let(:to) { Time.zone.now }
  let(:repository) { create(:repository) }

  let(:subject) do
    get repository_time_to_second_review_prs_repository_index_path(
      repository_name: repository.name
    ), params: params
  end

  let!(:first_pull_request) do
    create(:pull_request,
           repository: repository,
           html_url: 'test_pr_url_one',
           opened_at: Time.zone.now - 6.hours)
  end

  let!(:second_pull_request) do
    create(:pull_request,
           repository: repository,
           html_url: 'test_pr_url_two',
           opened_at: Time.zone.now - 14.hours)
  end

  let!(:third_pull_request) do
    create(:pull_request,
           repository: repository,
           html_url: 'test_pr_url_three',
           opened_at: Time.zone.now - 26.hours)
  end

  let(:prs) { [first_pull_request, second_pull_request, third_pull_request] }

  before do
    prs.each do |pr|
      create(:review_request,
             owner: user1,
             reviewer: user2,
             repository: pr.repository,
             pull_request: pr)

      create(:review,
             owner: user2,
             repository: pr.repository,
             pull_request: pr,
             review_request: ReviewRequest.last)

      create(:review_request,
             owner: user1,
             reviewer: user3,
             repository: pr.repository,
             pull_request: pr)

      create(:review,
             owner: user3,
             repository: pr.repository,
             pull_request: pr,
             review_request: ReviewRequest.last)
    end
  end

  context 'With correct params' do
    let(:params) do
      {
        metric: {
          from: from,
          to: to
        }
      }
    end

    before { subject }

    it 'renders pull requests index view' do
      expect(response).to render_template(:index)
    end

    it 'returns pull requests variable with data' do
      expect(assigns(:pull_requests)).not_to be_empty
    end

    it 'returns ony one PR from each range' do
      expect(assigns(:pull_requests)['1-12'].count).to eq(1)
      expect(assigns(:pull_requests)['12-24'].count).to eq(1)
      expect(assigns(:pull_requests)['24-36'].count).to eq(1)
    end
  end
end
