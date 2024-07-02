# == Schema Information
#
# Table name: file_ignoring_rules
#
#  id          :bigint           not null, primary key
#  regex       :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  language_id :bigint           not null
#
# Indexes
#
#  index_file_ignoring_rules_on_language_id  (language_id)
#
# Foreign Keys
#
#  fk_rails_...  (language_id => languages.id)
#

class FileIgnoringRule < ApplicationRecord
  belongs_to :language

  validates :regex, presence: true

  def matches?(filename)
    filename.match?(regex)
  end

  RANSACK_ATTRIBUTES = %w[created_at id id_value language_id regex updated_at].freeze
end
