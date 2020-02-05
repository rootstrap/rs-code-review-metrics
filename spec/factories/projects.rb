# == Schema Information
#
# Table name: projects
#
#  id          :bigint           not null, primary key
#  description :string
#  lang        :enum             default("unassigned")
#  name        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  github_id   :integer          not null
#

FactoryBot.define do
  factory :project do
    sequence(:github_id, 1000)
    name { 'rs-code-review-metrics' }
    description { 'Github metrics' }
    lang { 'ruby' }

    factory :project_with_events do
      transient do
        events_count { 5 }
      end

      after(:create) do |project, evaluator|
        create_list(:event, evaluator.events_count, project: project)
      end
    end
  end
end
