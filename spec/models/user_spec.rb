# == Schema Information
#
# Table name: users
#
#  id                   :bigint           not null, primary key
#  company_member_since :date
#  company_member_until :date
#  login                :string           not null
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  github_id            :bigint           not null
#  node_id              :string           not null
#
# Indexes
#
#  index_users_on_github_id  (github_id) UNIQUE
#

require 'rails_helper'

RSpec.describe User, type: :model do
  subject { build :user }

  it { is_expected.to have_many(:owned_review_requests) }
  it { is_expected.to have_many(:owned_review_comments) }
  it { is_expected.to have_many(:owned_reviews) }
  it { is_expected.to have_many(:received_review_requests) }
  it { is_expected.to have_many(:users_repositories) }
  it { is_expected.to have_many(:repositories) }
  it { is_expected.to have_many(:created_pull_requests) }
  it { is_expected.to have_many(:owned_pull_request_comments) }
  it { is_expected.to validate_uniqueness_of(:github_id) }

  it 'is valid with valid attributes' do
    expect(subject).to be_valid
  end

  it 'is not valid without node id' do
    subject.node_id = nil
    expect(subject).to_not be_valid
  end

  it 'is not valid without github id' do
    subject.github_id = nil
    expect(subject).to_not be_valid
  end

  it 'is not valid without login' do
    subject.login = nil
    expect(subject).to_not be_valid
  end

  describe '.name' do
    it 'returns the login attribute' do
      expect(subject.login).to eq(subject.name)
    end
  end

  describe 'scopes' do
    describe '.company_member' do
      context 'when there is a member user' do
        let!(:member_user) { create(:user, company_member_since: Time.current) }

        it 'includes member_user' do
          expect(User.company_member).to include(member_user)
        end
      end
    end

    describe '.members_since' do
      context 'when there is a current member user' do
        let!(:member_user) do
          create(:user, company_member_since: 3.days.ago, company_member_until: 1.day.ago)
        end

        it 'includes member_user' do
          expect(User.members_since(2.days.ago)).to include(member_user)
        end
      end
    end

    describe '.bot_users' do
      let!(:bot_user) { create(:user, login: 'test[bot]') }
      let!(:regular_user) { create(:user, login: 'regular-user') }

      it 'returns only users with [bot] in their login' do
        expect(User.bot_users).to include(bot_user)
        expect(User.bot_users).not_to include(regular_user)
      end
    end

    describe '.ignored_users' do
      let!(:bot_user) { create(:user, login: 'test-[bot]') }
      let!(:ignored_user) { create(:user, login: 'ignored-user') }
      let!(:regular_user) { create(:user, login: 'regular-user') }
      let!(:ignored_users_setting) do
        create(:setting, key: 'ignored_users', value: ignored_user.login)
      end

      it 'returns bot users and users in the ignored list' do
        expect(User.ignored_users).to include(bot_user, ignored_user)
        expect(User.ignored_users).not_to include(regular_user)
      end
    end
  end
end
