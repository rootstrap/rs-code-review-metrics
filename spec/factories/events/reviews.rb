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
  factory :review, class: Events::Review do
    github_id { Faker::Number.unique.number(digits: 4) }
    state { %w[approved commented changes_requested].sample }

    association :pull_request, strategy: :build
    association :owner, factory: :user, strategy: :build
  end
end
