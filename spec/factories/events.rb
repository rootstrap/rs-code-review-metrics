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
    name { %w[pull_request review review_comment].sample }
    data { Faker::Json.shallow_json(width: 3) }
  end
end
