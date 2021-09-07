require 'rails_helper'

RSpec.describe 'External Pull Requests' do
  let!(:non_org_user) { create(:user) }
  let!(:current_org_user) { create(:user, company_member_since: 1.week.ago) }
  let!(:former_org_user) do
    create(:user, company_member_since: 5.weeks.ago, company_member_until: 3.weeks.ago)
  end
  let!(:disabled_external_repository) { create(:external_repository, enabled: false) }
  let!(:non_org_user_pull_request) do
    create(:external_pull_request, state: 'open', owner: non_org_user, opened_at: Time.current)
  end
  let!(:current_org_user_pull_request) do
    create(:external_pull_request, state: 'open', owner: current_org_user, opened_at: Time.current)
  end
  let!(:disabled_repository_pull_request) do
    create(:external_pull_request, state: 'open', owner: current_org_user,
                                   opened_at: Time.current,
                                   external_repository: disabled_external_repository)
  end
  let!(:former_org_user_pull_request) do
    create(:external_pull_request, state: 'open', owner: former_org_user, opened_at: Time.current)
  end
  let(:subject) do
    get external_pull_requests_path, params: params
  end

  before do
    subject
  end

  context 'when there is only 1 org member in given dates' do
    let(:params) do
      {
        from: 2
      }
    end

    it 'returns current_org_user_pull_request' do
      assert_equal({ current_org_user.login => [current_org_user_pull_request] },
                   assigns(:external_pull_requests))
    end

    it 'should not return disabled_repository_pull_request' do
      refute_includes(assigns(:external_pull_requests)[current_org_user.login],
                      disabled_repository_pull_request)
    end
  end

  context 'when there are 2 org members in given dates' do
    let(:params) do
      {
        from: 4
      }
    end

    it 'returns current_org_user_pull_request and former_org_user_pull_request' do
      assert_equal({ current_org_user.login => [current_org_user_pull_request],
                     former_org_user.login => [former_org_user_pull_request] },
                   assigns(:external_pull_requests))
    end
  end
end
