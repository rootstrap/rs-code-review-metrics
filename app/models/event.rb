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
  TYPES = %w[pull_request review review_comment].freeze

  belongs_to :handleable, polymorphic: true, optional: true
  belongs_to :project

  validates :name, presence: true
  validates :data, presence: true
  validates :handleable, presence: true, if: proc { |event| event.handled_type? }
  validate :name_matches_handleable_type, if: proc { |event| handleable && event.handled_type? }

  scope :received_after, ->(time) { time ? where('created_at > ?', time) : nil }

  ##
  # Validate that the receiver name matches the class of the handleable Event.
  # For example if handleable is a Events::PullRequest object the name is
  # expected to be 'pull_request'
  def name_matches_handleable_type
    return if name == handleable.event_name

    errors.add(:name_matches_handleable_type, 'event name must match event type')
  end

  ##
  # Return true if the event name is included in the Event handled types
  def handled_type?
    TYPES.include?(name)
  end
end
