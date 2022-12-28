namespace :one_time do
  desc 'it sets pull_request to completed review turnarounds'
  task set_pull_request_to_completed_review_turnaround: :environment do
    puts 'Setting pull_request to completed review_turnarounds...'
    Processors::CompletedReviewTurnaroundPullRequestBackfiller.call
    puts 'Done!'
  end
end
