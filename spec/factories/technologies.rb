# == Schema Information
#
# Table name: technologies
#
#  id             :bigint           not null, primary key
#  keyword_string :text
#  name           :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
FactoryBot.define do
  factory :technology do
    name { Faker::Lorem.word }
    keyword_string { Faker::Lorem.word }
  end
end
