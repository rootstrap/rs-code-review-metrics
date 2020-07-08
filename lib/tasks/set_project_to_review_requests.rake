# frozen_string_literal: true

namespace :one_time do
  desc 'it sets project to review requests'
  task set_project_to_review_requests: :environment do
    puts 'Setting project to review requests...'
    ReviewRequest.includes(pull_request: :project).each do |rq|
      rq.update!(project: rq.pull_request.project)
    end
    puts 'Done!'
  end
end
