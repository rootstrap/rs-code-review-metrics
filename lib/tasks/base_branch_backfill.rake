namespace :base_branch do
  desc 'Backfill base branch for existing pull requests'
  task backfill: :environment do
    puts 'Starting base branch backfill...'

    pull_requests = Events::PullRequest
                    .where(base_branch: [nil, ''])
                    .joins(:events)
                    .where(events: { name: 'pull_request' })
                    .distinct

    total = pull_requests.count
    puts "Found #{total} pull requests to process"

    pull_requests.find_each do |pull_request|
      event = pull_request.events.find_by(name: 'pull_request')

      if event&.data&.dig('pull_request', 'base', 'ref')
        pull_request.update!(base_branch: event.data.dig('pull_request', 'base', 'ref'))
      else
        puts "✗ Could not find base branch data for PR ##{pull_request.number},
              repository #{pull_request.repository.id}"
      end
    rescue StandardError => exception
      puts "✗ Error processing PR ##{pull_request.number}
            in repository #{pull_request.repository.id}: #{exception.message}"
    end

    puts 'Base branch backfill completed!'
  end
end
