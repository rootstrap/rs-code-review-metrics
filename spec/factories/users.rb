# == Schema Information
#
# Table name: users
#
#  id         :bigint           not null, primary key
#  login      :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  github_id  :bigint           not null
#  node_id    :string           not null
#
# Indexes
#
#  index_users_on_github_id  (github_id) UNIQUE
#

FactoryBot.define do
  factory :user do
    sequence(:github_id, 1000)
    sequence(:login, 100) { |n| "octocat#{n}" }
    node_id { 'MDQ6VXNlcjE=' }

    factory :user_with_owned_review_requests do
      transient do
        owned_review_requests_count { 5 }
      end

      after(:create) do |user, evaluator|
        create_list(:owned_review_request,
                    evaluator.owned_review_requests_count,
                    user: user)
      end
    end

    factory :user_with_received_review_requests do
      transient do
        received_review_requests_count { 5 }
      end

      after(:create) do |user, evaluator|
        create_list(:received_review_request,
                    evaluator.received_review_requests_count,
                    user: user)
      end
    end
  end
end
