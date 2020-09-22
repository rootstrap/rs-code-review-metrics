# == Schema Information
#
# Table name: code_climate_project_metrics
#
#  id                    :bigint           not null, primary key
#  code_climate_rate     :string
#  invalid_issues_count  :integer
#  open_issues_count     :integer
#  snapshot_time         :datetime
#  test_coverage         :decimal(, )
#  wont_fix_issues_count :integer
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  cc_repository_id      :string
#  project_id            :bigint           not null
#
# Indexes
#
#  index_code_climate_project_metrics_on_project_id  (project_id)
#
# Foreign Keys
#
#  fk_rails_...  (project_id => projects.id)
#

FactoryBot.define do
  factory :code_climate_project_metric do
    project
    code_climate_rate { %w[A B C D].sample }
    invalid_issues_count { Faker::Number.between(from: 0, to: 30) }
    open_issues_count { Faker::Number.between(from: 0, to: 30) }
    wont_fix_issues_count { Faker::Number.between(from: 0, to: 30) }
    snapshot_time { Faker::Date.between(from: 1.month.ago, to: Time.zone.now) }
    updated_at { DateTime.current }
    cc_repository_id { Faker::Alphanumeric.alphanumeric(number: 24) }
    test_coverage { Faker::Number.decimal(l_digits: 2, r_digits: 10) }
  end
end
