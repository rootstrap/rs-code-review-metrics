# == Schema Information
#
# Table name: code_climate_project_metrics
#
#  id                    :bigint           not null, primary key
#  code_climate_rate     :string
#  invalid_issues_count  :integer
#  wont_fix_issues_count :integer
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
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
    invalid_issues_count { Faker::Number.between(from: 0, to: 99) }
    wont_fix_issues_count { Faker::Number.between(from: 0, to: 99) }
  end
end
