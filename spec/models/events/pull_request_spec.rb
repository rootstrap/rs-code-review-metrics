# == Schema Information
#
# Table name: events_pull_requests
#
#  id            :bigint           not null, primary key
#  body          :text
#  branch        :string
#  closed_at     :datetime
#  draft         :boolean          not null
#  html_url      :string
#  locked        :boolean          not null
#  merged_at     :datetime
#  number        :integer          not null
#  opened_at     :datetime
#  size          :integer
#  state         :enum
#  title         :text             not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  github_id     :bigint           not null
#  node_id       :string           not null
#  owner_id      :bigint
#  repository_id :bigint
#
# Indexes
#
#  index_events_pull_requests_on_github_id      (github_id) UNIQUE
#  index_events_pull_requests_on_owner_id       (owner_id)
#  index_events_pull_requests_on_repository_id  (repository_id)
#  index_events_pull_requests_on_state          (state)
#
# Foreign Keys
#
#  fk_rails_...  (owner_id => users.id)
#  fk_rails_...  (repository_id => repositories.id)
#  fk_rails_...  (repository_id => repositories.id)
#

require 'rails_helper'

RSpec.describe Events::PullRequest, type: :model do
  context 'validations' do
    subject { build :pull_request }

    it { is_expected.to have_many(:events) }
    it { is_expected.to belong_to(:owner) }
    it { is_expected.to validate_presence_of(:opened_at) }
    it { is_expected.to validate_presence_of(:github_id) }
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:state) }
    it { is_expected.to validate_presence_of(:number) }
    it { is_expected.to validate_presence_of(:node_id) }

    it 'is valid with valid attributes' do
      expect(subject).to be_valid
    end

    it 'is not valid without locked' do
      subject.locked = nil
      expect(subject).to_not be_valid
    end

    it 'is not valid without draft' do
      subject.draft = nil
      expect(subject).to_not be_valid
    end

    context 'when github id is already been taken' do
      let!(:pull_request) { create(:pull_request, github_id: 100) }

      it 'raise uniqueness exception' do
        subject.github_id = 100

        expect {
          subject.save!
        }.to raise_error(PullRequests::GithubUniquenessError)
      end
    end
  end
end
