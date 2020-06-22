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

FactoryBot.define do
  factory :department do
    sequence(:name) { |n| %i[backend frontend mobile][n - 1] }
  end
end
