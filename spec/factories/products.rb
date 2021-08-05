# == Schema Information
#
# Table name: products
#
#  id               :bigint           not null, primary key
#  description      :string
#  jira_project_key :string
#  name             :string           not null
#
# Indexes
#
#  index_products_on_name  (name)
#

FactoryBot.define do
  factory :product do
    name { Faker::Name.name.gsub(' ', '') }
    description { Faker::Lorem.sentence }
  end
end
