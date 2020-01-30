module EventAssociator
  def assign_event(payload, event)
    Event.create!(handleable: event,
                  name: payload.event,
                  data: payload)
  end
end
