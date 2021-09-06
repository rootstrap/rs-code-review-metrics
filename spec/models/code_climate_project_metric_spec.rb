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

require 'rails_helper'

RSpec.describe CodeClimateProjectMetric, type: :model do
  it { is_expected.to belong_to(:repository) }

  it do
    is_expected.to have_db_column(:code_climate_rate)
      .of_type(:string)
      .with_options(null: true)
  end

  it do
    is_expected.to have_db_column(:invalid_issues_count)
      .of_type(:integer)
      .with_options(null: true)
  end

  it do
    is_expected.to have_db_column(:open_issues_count)
      .of_type(:integer)
      .with_options(null: true)
  end

  it do
    is_expected.to have_db_column(:wont_fix_issues_count)
      .of_type(:integer)
      .with_options(null: true)
  end

  it do
    is_expected.to have_db_column(:snapshot_time)
      .of_type(:datetime)
      .with_options(null: true)
  end
end
