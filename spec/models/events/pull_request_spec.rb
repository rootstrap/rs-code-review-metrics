# == Schema Information
#
# Table name: pull_requests
#
#  id         :bigint           not null, primary key
#  body       :text
#  branch     :string
#  closed_at  :datetime
#  draft      :boolean          not null
#  html_url   :string
#  locked     :boolean          not null
#  merged_at  :datetime
#  number     :integer          not null
#  opened_at  :datetime
#  state      :enum
#  title      :text             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  github_id  :bigint           not null
#  node_id    :string           not null
#  owner_id   :bigint
#  project_id :bigint
#
# Indexes
#
#  index_pull_requests_on_github_id   (github_id) UNIQUE
#  index_pull_requests_on_owner_id    (owner_id)
#  index_pull_requests_on_project_id  (project_id)
#  index_pull_requests_on_state       (state)
#
# Foreign Keys
#
#  fk_rails_...  (owner_id => users.id)
#  fk_rails_...  (project_id => projects.id)
#

require 'rails_helper'

RSpec.describe Events::PullRequest, type: :model do
  context 'validations' do
    subject { build :pull_request }

    it { is_expected.to have_many(:events) }
    it { is_expected.to belong_to(:owner) }
    it { is_expected.to validate_uniqueness_of(:github_id) }
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
  end

  describe 'callbacks' do
    context 'when a pull request is merged' do
      before { travel_to(Time.zone.today.beginning_of_day) }
      let!(:pull_request) { create(:pull_request, opened_at: Time.current) }

      it 'creates a merge time with the correct values' do
        pull_request.update!(merged_at: Time.current + 1.hour)
        merge_time = MergeTime.last
        expect(merge_time[:value].seconds).to eq(1.hour)
        expect(merge_time[:pull_request_id]).to eq(pull_request.id)
      end

      it 'creates a merge time' do
        expect {
          pull_request.update!(merged_at: Time.current)
        }.to change { MergeTime.count }.from(0).to(1)
      end
    end
  end
end
