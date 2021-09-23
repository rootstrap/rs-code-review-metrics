# == Schema Information
#
# Table name: alerts
#
#  id             :bigint           not null, primary key
#  active         :boolean
#  emails         :string
#  frequency      :integer
#  last_sent_date :datetime
#  metric_name    :string
#  name           :string
#  threshold      :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  department_id  :bigint
#  repository_id  :bigint
#
# Indexes
#
#  index_alerts_on_department_id  (department_id)
#  index_alerts_on_repository_id  (repository_id)
#
# Foreign Keys
#
#  fk_rails_...  (department_id => departments.id)
#  fk_rails_...  (repository_id => repositories.id)
#

FactoryBot.define do
  factory :alert do
    name { Faker::Name.name }
    metric_name do
      %w[review_turnaround merge_time pull_request_size].sample
    end
    active { [true, false].sample }
    emails { Faker::Internet.email + ',' + Faker::Internet.email }
    frequency { Faker::Number.between(from: 0, to: 7) }
    threshold { Faker::Number.between(from: 0, to: 100) }
    last_sent_date { Time.zone.today }

    repository
    department

    trait :with_repository do
      department { nil }
    end

    trait :with_department do
      repository { nil }
    end
  end
end
