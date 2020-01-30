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
  belongs_to :handleable, polymorphic: true, required: false
  validates :name, :data, presence: true

  EVENTS = %w[pull_request].freeze
  private_constant :EVENTS

  def resolve
    handle if handleable?
  end

  private

  def handle
    const_event.resolve(build_payload)
  end

  def build_payload
    data.merge(event_id: id)
  end

  def const_event
    Events.const_get(name.classify)
  end

  def handleable?
    EVENTS.include?(name)
  end
end
