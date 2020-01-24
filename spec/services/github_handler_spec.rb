require 'rails_helper'

describe GithubHandler do
  let(:github_handler) { GithubHandler.new('pull_request', '', 'stub') }

  it 'enqueues opened job' do
    expect {
      github_handler.opened
    }.to have_enqueued_job(GithubJobs::OpenedJob)
  end

  it 'enqueues closed job' do
    expect {
      github_handler.closed
    }.to have_enqueued_job(GithubJobs::ClosedJob)
  end

  it 'enqueues review requested job' do
    expect {
      github_handler.review_request
    }.to have_enqueued_job(GithubJobs::ReviewRequestJob)
  end

  it 'enqueues review removal job' do
    expect {
      github_handler.review_removal
    }.to have_enqueued_job(GithubJobs::ReviewRemovalJob)
  end
end
