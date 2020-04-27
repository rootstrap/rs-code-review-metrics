# == Schema Information
#
# Table name: technologies
#
#  id         :bigint           not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryBot.define do
  factory :technology do
    name { 'Ruby' }
  end
end
