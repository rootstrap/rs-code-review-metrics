class GithubService < BaseService
  include GithubEventPayloadHelper

  def initialize(payload:, event:)
    @payload = payload
    @event = event
  end

  def call
    handle_request
  end

  private

  def handle_request
    build_project
    handle_event
    raise Events::NotHandleableError unless @entity

    handle_action
  end

  def build_project
    repo = @payload['repository']
    @project = Project.find_or_create_by!(github_id: repo['id']) do |pj|
      pj.name = repo['name']
      pj.description = repo['description']
    end
  end

  def handle_event
    @entity = find_or_create_event_type

    Event.create!(project: @project,
                  data: @payload,
                  name: @event,
                  handleable: @entity,
                  occurred_at: occurence_time(event_name: @event, payload: @payload))
  end

  def handleable_event?
    handleable_event_type?(@event)
  end

  def find_or_create_event_type
    return unless handleable_event?

    EventBuilders.const_get(@event.classify).call(payload: @payload, event: @event)
  end

  def handle_action
    ActionHandlers.const_get(@event.classify).call(payload: @payload,
                                                   event: @event,
                                                   entity: @entity)
  end
end
