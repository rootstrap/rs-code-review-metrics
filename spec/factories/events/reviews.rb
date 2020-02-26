# == Schema Information
#
# Table name: reviews
#
#  id              :bigint           not null, primary key
#  body            :string
#  state           :enum             not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  github_id       :integer
#  owner_id        :bigint
#  pull_request_id :bigint           not null
#
# Indexes
#
#  index_reviews_on_owner_id         (owner_id)
#  index_reviews_on_pull_request_id  (pull_request_id)
#  index_reviews_on_state            (state)
#
# Foreign Keys
#
#  fk_rails_...  (owner_id => users.id)
#  fk_rails_...  (pull_request_id => pull_requests.id)
#

FactoryBot.define do
  sequence(:review_id, 100)
  sequence(:review_state) { |n| Events::Review.states.values[n % 2] }

  factory :review, class: Events::Review do
    github_id { generate(:review_id) }
    state { generate(:review_state) }

    association :pull_request
    association :owner, factory: :user
  end
end
