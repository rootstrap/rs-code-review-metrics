# == Schema Information
#
# Table name: pull_requests
#
#  id         :bigint           not null, primary key
#  body       :text
#  closed_at  :datetime
#  draft      :boolean          not null
#  locked     :boolean          not null
#  merged_at  :datetime
#  number     :integer          not null
#  opened_at  :datetime
#  state      :enum
#  title      :text             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  github_id  :bigint           not null
#  node_id    :string           not null
#
# Indexes
#
#  index_pull_requests_on_github_id  (github_id) UNIQUE
#

FactoryBot.define do
  factory :pull_request, class: Events::PullRequest do
    sequence(:github_id, 1000)
    sequence(:number, 2)
    sequence(:title) { |n| "Pull Request-#{n}" }
    node_id { 'MDExOlB1bGxSZXF1ZXN0Mjc5MTQ3NDM3' }
    state { 'open' }
    locked { false }
    draft { false }

    factory :pull_request_with_events do
      transient do
        events_count { 5 }
      end

      after(:create) do |pull_request, evaluator|
        create_list(:event, evaluator.events_count, pull_request: pull_request)
      end
    end

    factory :pull_request_with_review_requests do
      transient do
        review_requests_count { 5 }
      end

      after(:create) do |pull_request, evaluator|
        create_list(:review_request,
                    evaluator.review_requests_count,
                    pull_request: pull_request)
      end
    end
  end
end
