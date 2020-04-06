module GithubEventPayloadHelper
  private

  ##
  # Returns the occurrence time of the 'pull_request' event.
  def pull_request_ocurrence_time(payload:)
    parse_time_string(payload.fetch('pull_request').fetch('updated_at'))
  end

  ##
  # Returns the occurrence time of the 'review_comment' event.
  def review_comment_ocurrence_time(payload:)
    parse_time_string(payload.fetch('comment').fetch('updated_at'))
  end

  ##
  # Returns the occurrence time of the 'review' event.
  ##
  def review_ocurrence_time(payload:)
    event_action = payload.fetch('action')
    review_payload = payload.fetch('review')
    case event_action
    when 'submitted'
      parse_time_string(review_payload.fetch('submitted_at'))
    when 'edited'
      parse_time_string(review_payload.fetch('edited_at'))
    when 'dismissed'
      parse_time_string(review_payload.fetch('dismissed_at'))
    else
      raise "Uknown action '#{event_action}'"
    end
  end

  ##
  # Parses the given time_string and returns a TimeWithZone object
  def parse_time_string(time_string)
    Time.zone.parse(time_string)
  end
end
