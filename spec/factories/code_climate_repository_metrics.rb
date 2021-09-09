# == Schema Information
#
# Table name: code_climate_repository_metrics
#
#  id                    :bigint           not null, primary key
#  code_climate_rate     :string
#  deleted_at            :datetime
#  invalid_issues_count  :integer
#  open_issues_count     :integer
#  snapshot_time         :datetime
#  test_coverage         :decimal(, )
#  wont_fix_issues_count :integer
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  cc_repository_id      :string
#  repository_id         :bigint           not null
#
# Indexes
#
#  index_code_climate_repository_metrics_on_repository_id  (repository_id)
#
# Foreign Keys
#
#  fk_rails_...  (repository_id => repositories.id)
#  fk_rails_...  (repository_id => repositories.id)
#

FactoryBot.define do
  factory :code_climate_repository_metric do
    repository
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
