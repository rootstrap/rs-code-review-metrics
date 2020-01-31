# == Schema Information
#
# Table name: pull_requests
#
#  id         :bigint           not null, primary key
#  body       :text
#  closed_at  :datetime
#  draft      :boolean          not null
#  locked     :boolean          not null
#  merged     :boolean          not null
#  merged_at  :datetime
#  number     :integer          not null
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

    it 'is not valid without merged' do
      subject.merged = nil
      expect(subject).to_not be_valid
    end

    it 'is not valid without draft' do
      subject.draft = nil
      expect(subject).to_not be_valid
    end

    it { should validate_uniqueness_of(:github_id) }
    it { should have_many(:events) }
  end

  context 'jobs' do
    describe '#opened' do
      it 'enqueues opened' do
        expect {
          described_class.resolve(action: 'opened')
        }.to have_enqueued_job(PullRequestJobs::Opened)
      end
    end

    describe '#closed' do
      it 'enqueues closed' do
        expect {
          described_class.resolve(action: 'closed')
        }.to have_enqueued_job(PullRequestJobs::Closed)
      end
    end

    describe '#review_requested' do
      it 'enqueues review requested' do
        expect {
          described_class.resolve(action: 'review_requested')
        }.to have_enqueued_job(PullRequestJobs::ReviewRequested)
      end
    end

    describe '#review_request_removed' do
      it 'enqueues review removal' do
        expect {
          described_class.resolve(action: 'review_request_removed')
        }.to have_enqueued_job(PullRequestJobs::ReviewRequestRemoved)
      end
    end

    describe '#merged' do
      it 'enqueues merged' do
        expect {
          described_class.resolve(action: 'merged')
        }.to have_enqueued_job(PullRequestJobs::Merged)
      end
    end
  end
end
