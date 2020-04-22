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

  validates :name, :data, presence: true
end
