class ActionHandler < BaseService
  def initialize(payload:, event:, event_type:)
    @payload = payload
    @event = event
    @event_type = event_type
  end

  def call
    return unless handleable?

    handle_action
  end

  private

  def find_user
    User.find_by!(github_id: @payload['requested_reviewer']['id'])
  end

  def handle_action
    send(@payload['action'])
  end
end
