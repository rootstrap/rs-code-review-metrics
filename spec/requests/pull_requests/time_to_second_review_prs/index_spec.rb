require 'rails_helper'

RSpec.describe 'PullRequests::TimeToSecondReviewPrsController' do
  let(:user1) { create(:user, login: 'user1') }
  let(:user2) { create(:user, login: 'user2') }
  let(:user3) { create(:user, login: 'user3') }

  let(:ruby_repository)  { create(:repository, language: Language.find_by(name: 'ruby')) }
  let(:node_repository)  { create(:repository, language: Language.find_by(name: 'nodejs')) }
  let(:subject) do
    get department_time_to_second_review_prs_path(department_name: 'backend'), params: params
  end

  let!(:first_ruby_pull_request) do
    create(:pull_request,
           repository: ruby_repository,
           owner: user1,
           html_url: 'ruby_pr_url',
           opened_at: Time.zone.now - 6.hours)
  end

  let!(:node_pull_request) do
    create(:pull_request,
           repository: node_repository,
           owner: user1,
           html_url: 'node_pr_url',
           opened_at: Time.zone.now - 14.hours)
  end

  let!(:second_ruby_pull_request) do
    create(:pull_request,
           repository: ruby_repository,
           owner: user1,
           html_url: 'ruby_pr_url',
           opened_at: Time.zone.now - 26.hours)
  end

  let(:prs) { [first_ruby_pull_request, node_pull_request, second_ruby_pull_request] }

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

  context 'when lang param is present' do
    let(:params) do
      {
        metric: {
          period: 4,
          lang: ['ruby']
        }
      }
    end

    before do
      subject
    end

    it 'renders pull requests index view' do
      expect(response).to render_template(:index)
    end

    it 'returns pull requests variable with data' do
      expect(assigns(:pull_requests)).not_to be_empty
    end

    it 'returns data only for repositories filtered by the lang parameter' do
      assigns(:pull_requests).each do |_, pull_request_url|
        expect(pull_request_url).not_to include(node_pull_request.html_url)
      end
    end
  end

  context 'when lang param is not present' do
    let(:params) do
      {
        metric: {
          period: 4,
          lang: []
        }
      }
    end

    before do
      subject
    end

    let(:all_pull_requests_url) { Events::PullRequest.pluck(:html_url) }

    it 'renders pull requests index view' do
      expect(response).to render_template(:index)
    end

    it 'returns pull requests variable with data' do
      expect(assigns(:pull_requests)).not_to be_empty
    end

    it 'returns data only for all repositories' do
      assigns(:pull_requests).each do |_, pull_request_url|
        expect(all_pull_requests_url).to include(pull_request_url.first[:html_url])
      end
    end
  end
end
