# == Schema Information
#
# Table name: events_reviews
#
#  id                :bigint           not null, primary key
#  body              :string
#  opened_at         :datetime         not null
#  state             :enum             not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  github_id         :integer
#  owner_id          :bigint
#  pull_request_id   :bigint           not null
#  repository_id     :bigint
#  review_request_id :bigint
#
# Indexes
#
#  index_events_reviews_on_owner_id           (owner_id)
#  index_events_reviews_on_pull_request_id    (pull_request_id)
#  index_events_reviews_on_repository_id      (repository_id)
#  index_events_reviews_on_review_request_id  (review_request_id)
#  index_events_reviews_on_state              (state)
#
# Foreign Keys
#
#  fk_rails_...  (owner_id => users.id)
#  fk_rails_...  (pull_request_id => events_pull_requests.id)
#  fk_rails_...  (repository_id => repositories.id)
#

FactoryBot.define do
  sequence(:review_id, 100)
  sequence(:review_state) { |n| Events::Review.states.values[n % 2] }

  factory :review, class: Events::Review do
    github_id { generate(:review_id) }
    state { generate(:review_state) }
    opened_at { Time.current }

    association :pull_request
    association :review_request
    association :owner, factory: :user
    association :repository
  end
end
