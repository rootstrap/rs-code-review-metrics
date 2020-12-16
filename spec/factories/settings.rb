# == Schema Information
#
# Table name: settings
#
#  id          :bigint           not null, primary key
#  description :string           default("")
#  key         :string           not null
#  value       :string
#
# Indexes
#
#  index_settings_on_key  (key) UNIQUE
#

FactoryBot.define do
  factory :setting do
    key   { Faker::Lorem.word }
    value { Faker::Lorem.word }
  end
end
