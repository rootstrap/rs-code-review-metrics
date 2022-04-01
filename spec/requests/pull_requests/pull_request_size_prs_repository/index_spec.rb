require 'rails_helper'

RSpec.describe 'Pull Request Size PRs Repository' do
  let(:repository) { create(:repository) }
  let(:from) { 4.weeks.ago }
  let(:to) { Time.zone.now }
  let(:wednesday) { Time.zone.today.last_week(:thursday) }
  let(:subject) do
    get repository_pull_request_size_prs_repository_index_path(
      repository_name: repository.name
    ), params: params
  end

  let!(:first_pull_request) do
    create(:pull_request,
           repository: repository,
           html_url: 'test_pr_url_one',
           size: Faker::Number.within(range: 1000..5000),
           opened_at: wednesday - 6.hours)
  end

  let!(:second_pull_request) do
    create(:pull_request,
           repository: repository,
           html_url: 'test_pr_url_two',
           size: Faker::Number.within(range: 1000..5000),
           opened_at: wednesday - 14.hours)
  end

  let!(:third_pull_request) do
    create(:pull_request,
           repository: repository,
           html_url: 'test_pr_url_three',
           size: Faker::Number.within(range: 1000..5000),
           opened_at: wednesday - 26.hours)
  end

  let!(:fourth_pull_request) do
    create(:pull_request,
           repository: repository,
           size: Faker::Number.within(range: 100..200),
           html_url: 'test_pr_url_four',
           opened_at: wednesday - 14.hours)
  end

  let!(:fifth_pull_request) do
    create(:pull_request,
           repository: repository,
           size: Faker::Number.within(range: 500..600),
           html_url: 'test_pr_url_five',
           opened_at: wednesday - 26.hours)
  end

  before do
    first_pull_request.update!(merged_at: wednesday)
    second_pull_request.update!(merged_at: wednesday)
    third_pull_request.update!(merged_at: wednesday)
    fourth_pull_request.update!(merged_at: wednesday)
    fifth_pull_request.update!(merged_at: wednesday)
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

    it 'returns only one PR from each range' do
      expect(assigns(:pull_requests)['100-199'].count).to eq(1)
      expect(assigns(:pull_requests)['500-599'].count).to eq(1)
      expect(assigns(:pull_requests)['1000+'].count).to eq(3)
    end
  end

  context 'With correct json params' do
    let(:params) do
      {
        metric: {
          from: from,
          to: to
        },
        format: 'json'
      }
    end

    before { subject }

    it 'returns json response' do
      expect(response.content_type).to include('application/json')
    end

    it 'returns data with the correct keys' do
      data = JSON.parse(response.body)

      expect(data.keys).to match_array(['100-199', '1000+', '500-599'])
    end
  end
end
