require 'rails_helper'

RSpec.describe 'PullRequests::TimeToMergePrsRepositoryController' do
  let(:repository) { create(:repository) }
  let(:from) { 4.weeks.ago }
  let(:to) { Time.zone.now }
  let(:wednesday) { Time.zone.today.last_week(:thursday) }
  let(:subject) do
    get repository_time_to_merge_prs_repository_index_path(
      repository_name: repository.name
    ), params: params
  end

  let!(:first_pull_request) do
    create(:pull_request,
           repository: repository,
           html_url: 'test_pr_url_one',
           opened_at: wednesday - 6.hours)
  end

  let!(:second_pull_request) do
    create(:pull_request,
           repository: repository,
           html_url: 'test_pr_url_two',
           opened_at: wednesday - 14.hours)
  end

  let!(:third_pull_request) do
    create(:pull_request,
           repository: repository,
           html_url: 'test_pr_url_three',
           opened_at: wednesday - 26.hours)
  end

  before do
    first_pull_request.update!(merged_at: wednesday)
    second_pull_request.update!(merged_at: wednesday)
    third_pull_request.update!(merged_at: wednesday)
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
