# == Schema Information
#
# Table name: languages
#
#  id            :bigint           not null, primary key
#  name          :string
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
  has_many :projects, dependent: :destroy
  has_many :metrics, as: :ownable, dependent: :destroy
end
