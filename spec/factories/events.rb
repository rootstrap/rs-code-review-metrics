# == Schema Information
#
# Table name: events
#
#  id              :bigint           not null, primary key
#  data            :jsonb
#  handleable_type :string
#  name            :string
#  occurred_at     :datetime
#  type            :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  handleable_id   :bigint
#  project_id      :bigint           not null
#
# Indexes
#
#  index_events_on_handleable_type_and_handleable_id  (handleable_type,handleable_id)
#  index_events_on_occurred_at                        (occurred_at)
#  index_events_on_project_id                         (project_id)
#

FactoryBot.define do
  sequence(:body) { |n| "Please change line #{n}" }

  factory :event do
    transient do
      action {}
      pull_request_payload {}
    end

    data { build :check_run_payload }

    name { 'check_run' }

    project

    occurred_at {}

    after(:build) do |event, factory|
      event.data['action'] = factory.action if factory.action
      event.data['pull_request'] = factory.pull_request_payload if factory.pull_request_payload
    end

    factory :event_pull_request do
      transient do
        created_at { Faker::Date.between(from: 1.month.ago, to: Time.zone.now) }
        updated_at { Faker::Date.between(from: created_at, to: Time.zone.now) }
      end

      name { handleable.event_name }
      data do
        build :pull_request_payload,
              action: action,
              created_at: created_at,
              updated_at: updated_at
      end
      association :handleable, factory: :pull_request
      occurred_at { Faker::Date.between(from: 1.month.ago, to: Time.zone.now) }
    end

    factory :event_review do
      transient do
        submitted_at {}
      end

      name { handleable.event_name }
      data { build :review_payload }
      association :handleable, factory: :review
      occurred_at { Faker::Date.between(from: 1.month.ago, to: Time.zone.now) }

      after(:build) do |event, factory|
        event.data['review']['submitted_at'] = factory.submitted_at.to_s if factory.submitted_at
      end
    end

    factory :event_review_comment do
      name { handleable.event_name }
      data { build :review_comment_payload }
      association :handleable, factory: :review_comment
      occurred_at { Faker::Date.between(from: 1.month.ago, to: Time.zone.now) }
    end
  end
end
