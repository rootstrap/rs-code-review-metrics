# == Schema Information
#
# Table name: completed_review_turnarounds
#
#  id                :bigint           not null, primary key
#  deleted_at        :datetime
#  value             :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  pull_request_id   :bigint
#  review_request_id :bigint           not null
#
# Indexes
#
#  index_completed_review_turnarounds_on_pull_request_id    (pull_request_id)
#  index_completed_review_turnarounds_on_review_request_id  (review_request_id)
#
# Foreign Keys
#
#  fk_rails_...  (pull_request_id => events_pull_requests.id)
#  fk_rails_...  (review_request_id => review_requests.id)
#

FactoryBot.define do
  factory :completed_review_turnaround do
    value { Faker::Number.number(digits: 4) }

    association :review_request
    association :pull_request
  end
end
