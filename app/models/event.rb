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
#  project_id      :bigint           not null
#
# Indexes
#
#  index_events_on_handleable_type_and_handleable_id  (handleable_type,handleable_id)
#  index_events_on_project_id                         (project_id)
#

class Event < ApplicationRecord
  EVENTS = %w[pull_request].freeze
  private_constant :EVENTS

  belongs_to :handleable, polymorphic: true, optional: true
  belongs_to :project
  validates :name, :data, presence: true

  def resolve
    return handle if handleable?

    save!
  end

  private

  def handle
    event = find_or_create_event
    update!(handleable: event)
    event.resolve
  end

  def find_or_create_event
    const_event.new.send("find_or_create_#{name}", data)
  end

  def const_event
    Events.const_get(name.classify)
  end

  def handleable?
    EVENTS.include?(name)
  end
end
