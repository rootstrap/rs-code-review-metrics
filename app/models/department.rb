# == Schema Information
#
# Table name: departments
#
#  id         :bigint           not null, primary key
#  name       :enum             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_departments_on_name  (name)
#

class Department < ApplicationRecord
  enum name: { mobile: 'mobile', backend: 'backend', frontend: 'frontend' }

  has_many :repositories, dependent: :nullify
  has_many :languages, dependent: :destroy
  has_many :metrics, as: :ownable, dependent: :destroy

  has_many :alerts, dependent: :destroy

  validates :name, inclusion: { in: names.keys }, uniqueness: true
end
