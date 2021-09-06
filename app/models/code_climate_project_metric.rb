# == Schema Information
#
# Table name: code_climate_project_metrics
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
#  index_code_climate_project_metrics_on_repository_id  (repository_id)
#
# Foreign Keys
#
#  fk_rails_...  (repository_id => repositories.id)
#  fk_rails_...  (repository_id => repositories.id)
#

class CodeClimateProjectMetric < ApplicationRecord
  acts_as_paranoid

  belongs_to :repository

  scope :with_rates, lambda {
    where.not(code_climate_rate: nil)
  }
end
