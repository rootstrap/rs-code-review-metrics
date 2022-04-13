# == Schema Information
#
# Table name: products
#
#  id          :bigint           not null, primary key
#  deleted_at  :datetime
#  description :string
#  enabled     :boolean          default(TRUE), not null
#  name        :string           not null
#  created_at  :datetime
#  updated_at  :datetime
#
# Indexes
#
#  index_products_on_deleted_at  (deleted_at)
#  index_products_on_enabled     (enabled)
#  index_products_on_name        (name)
#

FactoryBot.define do
  factory :product do
    name { Faker::Name.name.gsub(' ', '') }
    description { Faker::Lorem.sentence }
    enabled { true }
  end
end
