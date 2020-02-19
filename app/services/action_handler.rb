class ActionHandler < BaseService
  def initialize(payload:, event:, event_type:)
    @payload = payload
    @event = event
    @event_type = event_type
  end

  def call
    resolve
  end

  private

  def handle_action
    send(@payload['action'])
  end
end
