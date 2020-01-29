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
    return handle if handleable?

    save!
  end

  private

  def handle
    Event.create!(build_attributes)
  end

  def build_attributes
    {
      handleable: resolve_event,
      data: data,
      name: name
    }
  end

  def resolve_event
    const_event.new(payload).resolve
  end

  def const_event
    Events.const_get(name.classify)
  end

  def handleable?
    EVENTS.include?(name)
  end
end
