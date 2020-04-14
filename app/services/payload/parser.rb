module Payload
  class Parser
    def initialize(payload)
      @payload = payload
    end

    def pull_request_ocurrence_time
      Time.zone.parse(@payload['pull_request']['updated_at'])
    end

    def review_comment_ocurrence_time
      Time.zone.parse(@payload['comment']['updated_at'])
    end

    def review_ocurrence_time
      occurrence_time = @payload['review']["#{@payload['action']}_at"]
      Time.zone.parse(occurrence_time)
    end
  end
end
