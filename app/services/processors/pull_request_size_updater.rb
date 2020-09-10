module Processors
  class PullRequestSizeUpdater < BaseService
    def call
      Events::PullRequest.find_each(batch_size: 100).lazy.each do |pull_request|
        Builders::PullRequestSize.call(pull_request)
      end
    end
  end
end