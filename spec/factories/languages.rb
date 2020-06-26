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

FactoryBot.define do
  factory :language do
    sequence(:name) { |n| %w[ruby ios react unassigned][n % 4] }
  end
end
