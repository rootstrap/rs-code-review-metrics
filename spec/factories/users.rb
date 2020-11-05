# == Schema Information
#
# Table name: users
#
#  id             :bigint           not null, primary key
#  company_member :boolean          default(TRUE)
#  login          :string           not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  github_id      :bigint           not null
#  node_id        :string           not null
#
# Indexes
#
#  index_users_on_github_id  (github_id) UNIQUE
#

FactoryBot.define do
  sequence(:user_id, 100)

  factory :user do
    github_id { generate(:user_id) }
    login { "octocat#{Faker::Number.number}" }
    node_id { "#{Faker::Alphanumeric.alphanumeric}=" }
    company_member { true }
  end
end
