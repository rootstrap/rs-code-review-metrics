# == Schema Information
#
# Table name: events
#
#  id              :bigint           not null, primary key
#  data            :jsonb
#  handleable_type :string
#  name            :string
#  type            :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  handleable_id   :bigint
#
# Indexes
#
#  index_events_on_handleable_type_and_handleable_id  (handleable_type,handleable_id)
#

class Event < ApplicationRecord
  belongs_to :handleable, polymorphic: true, optional: true
  validates :name, :data, presence: true

  class << self
    def resolve(payload)
      event = payload[:event]
      return handle(payload) if handleable?(event)

      EventJob.perform_later(payload, event)
    end

    private

    EVENTS = %w[pull_request].freeze
    private_constant :EVENTS

    def handle(payload)
      const_event(payload[:event]).resolve(payload)
    end

    def const_event(event)
      Events.const_get(event.classify)
    end

    def handleable?(event)
      EVENTS.include?(event)
    end
  end
end
