# frozen_string_literal: true

namespace :one_time do
  desc 'it sets repository to review requests'
  task set_repository_to_review_requests: :environment do
    puts 'Setting repository to review requests...'
    ReviewRequest.includes(pull_request: :repository).find_each(batch_size: 500).lazy.each do |rq|
      rq.update!(repository: rq.pull_request.repository)
    end
    puts 'Done!'
  end
end
