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
        occurrence_time = payload['review']["#{payload['action']}_at"]
        Time.zone.parse(occurrence_time)
      end
    end
  end
end
