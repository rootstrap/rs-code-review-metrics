# == Schema Information
#
# Table name: external_projects
#
#  id          :bigint           not null, primary key
#  description :string
#  enabled     :boolean          default(TRUE), not null
#  full_name   :string           not null
#  name        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  github_id   :bigint           not null
#  language_id :bigint
#
# Indexes
#
#  index_external_projects_on_language_id  (language_id)
#

class ExternalProject < ApplicationRecord
  belongs_to :language, optional: true

  validates :github_id, :full_name, presence: true
  validates :github_id, uniqueness: true

  before_validation :set_default_language, on: :create

  scope :enabled, -> { where(enabled: true) }

  private

  def set_default_language
    return unless language.nil?

    self.language = Language.unassigned
  end
end
