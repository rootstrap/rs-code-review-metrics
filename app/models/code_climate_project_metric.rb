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

class CodeClimateProjectMetric < ApplicationRecord
  belongs_to :project

  scope :with_rates, lambda {
    where.not(code_climate_rate: nil)
  }
end
