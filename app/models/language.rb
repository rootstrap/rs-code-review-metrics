# == Schema Information
#
# Table name: languages
#
#  id            :bigint           not null, primary key
#  name          :string           not null
#  department_id :bigint
#
# Indexes
#
#  index_languages_on_department_id  (department_id)
#
# Foreign Keys
#
#  fk_rails_...  (department_id => departments.id)
#

class Language < ApplicationRecord
  belongs_to :department, optional: true
  has_many :repositories, dependent: :destroy
  has_many :metrics, as: :ownable, dependent: :destroy
  has_many :repositories_metrics, through: :repositories, source: :metrics
  has_many :file_ignoring_rules, dependent: :destroy

  def self.unassigned
    find_by(name: 'unassigned')
  end
end
