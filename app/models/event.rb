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
#  repository_id   :bigint           not null
#
# Indexes
#
#  index_events_on_handleable_type_and_handleable_id  (handleable_type,handleable_id)
#  index_events_on_repository_id                      (repository_id)
#
# Foreign Keys
#
#  fk_rails_...  (repository_id => repositories.id)
#

class Event < ApplicationRecord
  TYPES = %w[pull_request review review_comment push repository].freeze

  belongs_to :handleable, polymorphic: true, optional: true
  belongs_to :repository

  validates :name, :data, presence: true

  RANSACK_ATTRIBUTES = %w[created_at data handleable_id handleable_type id id_value name repository_id type updated_at].freeze
end
