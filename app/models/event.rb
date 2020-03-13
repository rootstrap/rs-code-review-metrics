# == Schema Information
#
# Table name: events
#
#  id              :bigint           not null, primary key
#  data            :jsonb
#  handleable_type :string
#  name            :string
#  occurred_at     :datetime
#  type            :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  handleable_id   :bigint
#  project_id      :bigint           not null
#
# Indexes
#
#  index_events_on_handleable_type_and_handleable_id  (handleable_type,handleable_id)
#  index_events_on_occurred_at                        (occurred_at)
#  index_events_on_project_id                         (project_id)
#

class Event < ApplicationRecord
  TYPES = %w[pull_request review review_comment].freeze

  belongs_to :handleable, polymorphic: true, optional: true
  belongs_to :project

  validates :name, :data, presence: true
  validates :handleable, presence: true, if: proc { |event| event.handled_type? }
  validates_with EventNameValidator, if: proc { |event| handleable && event.handled_type? }
  validates :occurred_at, presence: true, if: proc { |event| event.handled_type? }

  scope :occurred_at, ->(time) { time ? where('occurred_at > ?', time) : all }

  ##
  # Return true if the event name is included in the Event handled types
  def handled_type?
    TYPES.include?(name)
  end

  ##
  # Return the name of the handleable type
  def handleable_type_name
    handleable.event_name
  end
end
