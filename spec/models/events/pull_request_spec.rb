# == Schema Information
#
# Table name: pull_requests
#
#  id         :bigint           not null, primary key
#  body       :text
#  closed_at  :datetime
#  draft      :boolean          not null
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
#
# Indexes
#
#  index_pull_requests_on_github_id  (github_id) UNIQUE
#

require 'rails_helper'

RSpec.describe Events::PullRequest, type: :model do
  let(:raw_payload) do
    {
      pull_request: {
        id: 1001,
        number: 2,
        state: 'open',
        node_id: 'MDExOlB1bGxSZXF1ZXN0Mjc5MTQ3NDM3',
        title: 'Pull Request 2',
        locked: false,
        merged: false,
        draft: false,
        user: {
          node_id: 'MDQ6NlcjE4',
          login: 'heptacat',
          id: 1006
        }
      },
      requested_reviewer: {
        node_id: 'MDExOlB1bGxc5MTQ3NDM3',
        login: 'octocat',
        id: 1004
      }
    }.deep_stringify_keys
  end

  context 'validations' do
    subject { build :pull_request }

    it 'is valid with valid attributes' do
      expect(subject).to be_valid
    end

    it 'is not valid without github id' do
      subject.github_id = nil
      expect(subject).to_not be_valid
    end

    it 'is not valid without title' do
      subject.title = nil
      expect(subject).to_not be_valid
    end

    it 'is not valid without state' do
      subject.state = nil
      expect(subject).to_not be_valid
    end

    it 'is not valid without number' do
      subject.number = nil
      expect(subject).to_not be_valid
    end

    it 'is not valid without node id' do
      subject.node_id = nil
      expect(subject).to_not be_valid
    end

    it 'is not valid without locked' do
      subject.locked = nil
      expect(subject).to_not be_valid
    end

    it 'is not valid without draft' do
      subject.draft = nil
      expect(subject).to_not be_valid
    end

    it { is_expected.to validate_uniqueness_of(:github_id) }
    it { is_expected.to have_many(:events) }
  end

  describe 'actions' do
    subject { create :pull_request, payload: raw_payload }

    describe '#review_request' do
      before { change_action_to 'review_requested' }

      it 'creates a review request' do
        expect {
          subject.resolve
        }.to change(ReviewRequest, :count).by(1).and change(User, :count).by(2)
      end
    end

    describe '#closed' do
      before { change_action_to 'closed' }

      it 'sets status closed' do
        expect {
          subject.resolve
        }.to change { subject.reload.closed? }.from(false).to(true)
      end
    end

    describe '#open' do
      before { change_action_to 'open' }

      it 'sets status open' do
        subject.closed!

        expect {
          subject.resolve
        }.to change { subject.reload.open? }.from(false).to(true)
      end
    end

    describe '#merged' do
      before do
        change_action_to 'closed'
        subject.payload['pull_request']['merged'] = true
      end

      it 'sets status merged' do
        expect {
          subject.resolve
        }.to change { subject.reload.merged_at }
      end
    end

    describe '#review_request_removed' do
      before { change_action_to 'review_request_removed' }
      let!(:pull_request) { create :pull_request_with_review_requests, payload: raw_payload }

      it 'sets status to removed' do
        review_request = User.find_by!(github_id: raw_payload['requested_reviewer']['id'])
                             .received_review_requests.first
        expect {
          pull_request.resolve
        }.to change { review_request.reload.removed? }.from(false).to(true)
      end
    end
  end

  describe '#find_or_create_pull_request' do
    subject { build :pull_request }

    it 'creates a pull request' do
      expect {
        subject.send(:find_or_create_pull_request, raw_payload)
      }.to change(described_class, :count).by(1)
    end

    it 'finds a pull request' do
      subject.github_id = raw_payload['pull_request']['id']
      subject.save!

      expect(subject.send(:find_or_create_pull_request, raw_payload)).to eq(subject)
    end
  end
end
