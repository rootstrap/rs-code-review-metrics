class ActionHandler < BaseService
  def initialize(payload:, event:)
    @payload = payload
    @event = event
  end

  def call
    resolve
  end

  private

  def handle_action
    send(@payload['action'])
  end
end
