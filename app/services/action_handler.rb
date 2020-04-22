class ActionHandler < BaseService
  def initialize(payload:, entity:)
    @payload = payload
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
