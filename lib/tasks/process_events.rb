# A script to process again every event.

reviews =       Event.where("(data->'review') is not null").pluck(:data).pluck('review');1
pull_requests = Event.where("(data->'pull_request') is not null").pluck(:data).pluck('pull_request');1
comments =      Event.where("(data->'comment') is not null").pluck(:data).pluck('comment');1

# Gets 
# reviews_prs = reviews.pluck('pull_request_url').map { |x| x[/\d+/] }

event_types = {  pull_request: pull_requests, review_comment: comments };1

pull_requests.each do |event|
  event['github_id'] = event.delete('id')
  event.select! { |v| Events::PullRequest.column_names.include?(v) }
end

comments.each do |event|
  event['github_id'] = event.delete('id')
  event.select! { |v| Events::ReviewComment.column_names.include?(v) }
end

event_types.each do |event_type, events|
  event_class = Events.const_get(event_type.to_s.classify)

  # Import the records in batches
  events.in_groups_of(100) do |events_batch|
    begin
      event_class.import(events_batch)
    rescue ActiveRecord::RecordNotUnique => e
      next if(e.message =~ /unique.*constraint.*index_pull_requests_on_github_id/)
      raise
    end
  end
end
