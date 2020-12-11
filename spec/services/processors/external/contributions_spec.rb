require 'rails_helper'

RSpec.describe Processors::External::Contributions do
  let!(:actual_member) { create(:user, company_member_since: 1.day.ago) }
  let!(:actual_member_2) { create(:user, company_member_since: 1.day.ago) }
  let!(:not_member) { create(:user) }

  before do
    @job_adapter = ActiveJob::Base.queue_adapter
    ActiveJob::Base.queue_adapter = :test
  end

  after do
    ActiveJob::Base.queue_adapter = @job_adapter
  end

  describe '#call' do
    it 'enqueues as many jobs as the number of member users' do
      described_class.call

      expect(ExternalPullRequestsProcessorJob).to have_been_enqueued.exactly(2)
    end

    it 'enqueues a job per member username' do
      described_class.call
      usernames_enqueued = enqueued_jobs.flat_map { |job| job['arguments'] }

      expect(usernames_enqueued).to include(actual_member.login, actual_member_2.login)
    end

    it 'does not enqueue any job for non company users' do
      described_class.call
      usernames_enqueued = enqueued_jobs.flat_map { |job| job['arguments'] }

      expect(usernames_enqueued).not_to include(not_member.login)
    end
  end
end
