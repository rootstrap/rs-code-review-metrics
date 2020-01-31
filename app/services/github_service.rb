class GithubService < BaseService
  include PayloadParser

  def initialize(payload)
    @payload = parse_payload(payload)
  end

  def assign_event(payload, event)
    Event.create!(handleable: event,
                  name: payload.event,
                  data: payload)
  end
end
