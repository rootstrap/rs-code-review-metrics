class ActionHandler < BaseService
  private_constant :ACTIONS

  def initialize(payload:, event:, entity:)
    @payload = payload
    @event = event
    @entity = entity
  end

  def call
    return unless handleable?

    handle_action
  end

  private

  def handle_action
    send(@payload['action'])
  end
end
