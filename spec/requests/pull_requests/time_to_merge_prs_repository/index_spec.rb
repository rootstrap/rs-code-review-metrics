require 'rails_helper'

RSpec.describe 'Time To Merge PRs Repository' do
  let(:repository) { create(:repository) }

  let(:subject) do
    get repository_time_to_merge_prs_repository_index_path(
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

  before do
    first_pull_request.update!(merged_at: Time.zone.now)
    second_pull_request.update!(merged_at: Time.zone.now)
    third_pull_request.update!(merged_at: Time.zone.now)
  end

  context 'With correct params' do
    let(:params) do
      {
        metric: {
          period: 4
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

    it 'returns correct repositories' do
      expect(assigns(:pull_requests)['1-12'].count).to eq(2)
      expect(assigns(:pull_requests)['12-24'].count).to eq(1)
    end
  end
end
