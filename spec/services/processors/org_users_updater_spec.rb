describe Processors::OrgUsersUpdater do
  subject { Processors::OrgUsersUpdater }
  let(:update_all_org_users) { subject.call }
  let(:members_payload) { create(:members_payload) }

  before do
    stub_organization_members([members_payload])
  end

  context 'when a non-org user becomes an org member' do
    let(:user) { create(:user, login: members_payload['login'], company_member: false) }

    it('sets company_member boolean as true') do
      expect { update_all_org_users }.to change { user.reload.company_member }.from(false).to(true)
    end
  end

  context 'when an org user becomes an non-org member' do
    let(:non_org_user) { create(:user) }

    it('sets company_member boolean as false for that user') do
      expect { update_all_org_users }.to change {
        non_org_user.reload.company_member
      }.from(true).to(false)
    end
  end
end
