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
    name { handleable.event_name }
    data { Faker::Json.shallow_json(width: 3) }

    association :project, factory: :project

    trait :for_pull_request do
      association :handleable, factory: :pull_request
    end

    trait :for_review do
      association :handleable, factory: :review
    end

    trait :review_comment do
      association :handleable, factory: :review_comment
    end
  end
end
