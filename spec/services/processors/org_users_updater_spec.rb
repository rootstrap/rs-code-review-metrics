describe Processors::OrgUsersUpdater do
  subject { Processors::OrgUsersUpdater }
  let(:update_all_org_users) { subject.call }
  let(:members_payload) { create(:members_payload) }

  before do
    stub_organization_members([members_payload])
  end

  context 'when a non-org user becomes an org member' do
    let!(:user) { create(:user, login: members_payload['login']) }

    it('sets company_member_since date') do
      update_all_org_users
      expect(user.reload.company_member_since).not_to be(nil)
    end
  end

  context 'when an org user becomes an non-org member' do
    let!(:non_org_user) { create(:user, company_member_since: Time.current) }

    it('sets company_member_until date') do
      update_all_org_users
      expect(non_org_user.reload.company_member_until).not_to be(nil)
    end
  end
end
