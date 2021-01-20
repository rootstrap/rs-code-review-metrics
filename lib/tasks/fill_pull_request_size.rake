namespace :pull_requests do
  desc 'Pull requests sizes migration'
  task fill_size: :environment do
    PullRequestSize.find_each do |pull_request_size|
      value = pull_request_size.value
      pull_request_size.pull_request.update!(size: value)
    end
    Rails.logger { 'MIGRATION DONE' }
  end

  desc 'Fill missing pull requests sizes'
  task update_missing_sizes: :environment do
    Events::PullRequest.where(size: nil).find_each do |pull_request|
      Builders::PullRequestSize.call(pull_request)
    end
  end
end
