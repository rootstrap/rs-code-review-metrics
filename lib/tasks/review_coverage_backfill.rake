namespace :review_coverage do
  desc 'Backfill review coverage for merged pull requests'
  task backfill: :environment do
    puts 'Starting review coverage backfill...'

    pull_requests = Events::PullRequest
                    .where.not(merged_at: nil)
                    .where.not(id: ReviewCoverage.select(:pull_request_id))
                    .where(created_at: Time.current.beginning_of_year..Time.current)

    total = pull_requests.count
    puts "Found #{total} pull requests to process"

    pull_requests.find_each do |pull_request|
      Builders::ReviewCoverage.call(pull_request)
    rescue StandardError => exception
      puts "Error processing PR ##{pull_request.number}
            in repository #{pull_request.repository.id}: #{exception.message}"
    end

    puts 'Review coverage backfill completed!'
  end
end
