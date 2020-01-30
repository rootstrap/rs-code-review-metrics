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
    subject { create :pull_request }

    it { should_not allow_value(nil).for(:github_id) }
    it { should_not allow_value(nil).for(:title) }
    it { should_not allow_value(nil).for(:state) }
    it { should_not allow_value(nil).for(:number) }
    it { should_not allow_value(nil).for(:node_id) }
    it { should_not allow_value(nil).for(:locked) }
    it { should_not allow_value(nil).for(:merged) }
    it { should_not allow_value(nil).for(:draft) }
    it { should validate_uniqueness_of(:github_id) }
  end

  context 'jobs' do
    describe '#opened' do
      it 'enqueues opened' do
        expect {
          described_class.resolve(action: 'opened')
        }.to have_enqueued_job(PullRequestJobs::OpenedJob)
      end
    end

    describe '#closed' do
      it 'enqueues closed' do
        expect {
          described_class.resolve(action: 'closed')
        }.to have_enqueued_job(PullRequestJobs::ClosedJob)
      end
    end

    describe '#review_requested' do
      it 'enqueues review requested' do
        expect {
          described_class.resolve(action: 'review_requested')
        }.to have_enqueued_job(PullRequestJobs::ReviewRequestedJob)
      end
    end

    describe '#review_request_removed' do
      it 'enqueues review removal' do
        expect {
          described_class.resolve(action: 'review_request_removed')
        }.to have_enqueued_job(PullRequestJobs::ReviewRequestRemovedJob)
      end
    end

    describe '#merged' do
      it 'enqueues merged' do
        expect {
          described_class.resolve(action: 'merged')
        }.to have_enqueued_job(PullRequestJobs::MergedJob)
      end
    end
  end
end
