# == Schema Information
#
# Table name: completed_review_turnarounds
#
#  id                :bigint           not null, primary key
#  value             :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  review_request_id :bigint           not null
#
# Indexes
#
#  index_completed_review_turnarounds_on_review_request_id  (review_request_id)
#
# Foreign Keys
#
#  fk_rails_...  (review_request_id => review_requests.id)
#

FactoryBot.define do
  factory :completed_review_turnaround do
    value { Faker::Number.number(digits: 4) }

    association :review_request
  end
end
