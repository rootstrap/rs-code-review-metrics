# == Schema Information
#
# Table name: pull_request_sizes
#
#  id              :bigint           not null, primary key
#  value           :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  pull_request_id :bigint           not null
#
# Indexes
#
#  index_pull_request_sizes_on_pull_request_id  (pull_request_id)
#
# Foreign Keys
#
#  fk_rails_...  (pull_request_id => pull_requests.id)
#

FactoryBot.define do
  factory :pull_request_size do
    value { Faker::Number.within(range: 0..10_000) }

    association :pull_request
  end
end
