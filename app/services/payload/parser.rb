module Payload
  class Parser
    class << self
      def pull_request_ocurrence_time(payload)
        Time.zone.parse(payload['pull_request']['updated_at'])
      end

      def review_comment_ocurrence_time(payload)
        Time.zone.parse(payload['comment']['updated_at'])
      end

      def review_ocurrence_time(payload)
        event_action = payload['action']
        review_payload = payload['review']
        time_zone = Time.zone
        if event_action == 'submitted'
          time_zone.parse(review_payload['submitted_at'])
        elsif event_action == 'edited'
          time_zone.parse(review_payload['edited_at'])
        elsif event_action == 'dismissed'
          time_zone.parse(review_payload['dismissed_at'])
        end
      end
    end
  end
end
