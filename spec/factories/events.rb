# == Schema Information
#
# Table name: events
#
#  id              :bigint           not null, primary key
#  data            :jsonb
#  handleable_type :string
#  name            :string
#  type            :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  handleable_id   :bigint
#  project_id      :bigint           not null
#
# Indexes
#
#  index_events_on_handleable_type_and_handleable_id  (handleable_type,handleable_id)
#  index_events_on_project_id                         (project_id)
#

FactoryBot.define do
  sequence(:body) { |n| "Please change line #{n}" }

  factory :event do
    of_type_pull_request

    name { handleable.event_name }

    association :project, factory: :project

    trait :of_type_pull_request do
      data { build :pull_request_payload }
      association :handleable, factory: :pull_request
    end

    trait :of_type_review do
      data { build :review_payload }
      association :handleable, factory: :review
    end

    trait :of_type_comment do
      data { build :review_comment_payload }
      association :handleable, factory: :review_comment
    end
  end
end
