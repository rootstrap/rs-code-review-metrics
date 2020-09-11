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
    send(action)
  end

  def action
    @payload['action'] || :created
  end
end
