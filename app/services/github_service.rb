class GithubService < BaseService
  include GithubEventPayloadHelper
  include ProjectBuilder

  def initialize(payload:, event:)
    @payload = payload
    @event = event
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
    project = find_or_create_project(@payload['repository'])
    event = Event.new(project: project, data: @payload, name: @event)
    if handleable_event?
      @entity = find_or_create_event_type
      event.tap do |e|
        e.assign_attributes(handleable: @entity, occurred_at: occurence_time)
        e.save!
      end
    else
      event.tap(&:save!)
      raise Events::NotHandleableError
    end
  end

  def handleable_event?
    Event::TYPES.include?(@event)
  end

  def find_or_create_event_type
    EventBuilders.const_get(@event.classify).call(payload: @payload, event: @event)
  end

  def occurence_time
    send("#{@event}_ocurrence_time", payload: @payload)
  end

  def handle_action
    ActionHandlers.const_get(@event.classify).call(payload: @payload,
                                                   event: @event,
                                                   entity: @entity)
  end
end
