class GithubService < BaseService
  def initialize(payload:, event:)
    @payload = payload
    @event = resolve_event_name(event)
  end

  def call
    handle_request
  end

  private

  def handle_request
    handle_event
    handle_action
  end

  def handle_event
    project = Builders::Project.call(@payload['repository'])
    event = Event.new(project: project, data: @payload, name: @event)
    if handleable_event?
      @entity = find_or_create_event_type
      event.assign_attributes(handleable: @entity)
      event.save!
    else
      event.save!
      raise Events::NotHandleableError
    end
  end

  def resolve_event_name(event)
    return event.gsub('pull_request_', '') unless event == 'pull_request'

    event
  end

  def handleable_event?
    Event::TYPES.include?(@event)
  end

  def find_or_create_event_type
    Builders::Events.const_get(@event.classify).call(payload: @payload)
  end

  def handle_action
    ActionHandlers.const_get(@event.classify).call(payload: @payload,
                                                   entity: @entity)
  end
end
