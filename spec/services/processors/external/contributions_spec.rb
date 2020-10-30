require 'rails_helper'

RSpec.describe Processors::External::Contributions do
  let!(:users) { create_list(:user, 3) }

  before do
    @job_adapter = ActiveJob::Base.queue_adapter
    ActiveJob::Base.queue_adapter = :test
  end

  after do
    ActiveJob::Base.queue_adapter = @job_adapter
  end

  describe '#call' do
    it 'enqueues as many jobs as the number of users' do
      described_class.call

      expect(ExternalPullRequestsProcessorJob).to have_been_enqueued.exactly(3)
    end

    it 'enqueues a job per username' do
      described_class.call
      usernames_enqueued = enqueued_jobs.flat_map { |job| job['arguments'] }

      expect(usernames_enqueued).to include(*users.pluck(:login))
    end

    context 'when some users are not company members' do
      let!(:hvilloria) { create(:user, login: 'hvilloria') }
      let!(:sandrodamilano) { create(:user, login: 'sandrodamilano') }
      let!(:snick555) { create(:user, login: 'snick555', company_member: false) }

      it 'does not enqueue any job for non company users' do
        described_class.call
        usernames_enqueued = enqueued_jobs.flat_map { |job| job['arguments'] }

        expect(usernames_enqueued).not_to include(snick555.login)
      end

      it 'enqueues a job for every company member' do
        described_class.call
        usernames_enqueued = enqueued_jobs.flat_map { |job| job['arguments'] }

        expect(usernames_enqueued.size).to eq(5)
      end
    end
  end
end
