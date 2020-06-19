# == Schema Information
#
# Table name: code_climate_project_metrics
#
#  id                    :bigint           not null, primary key
#  code_climate_rate     :string
#  invalid_issues_count  :integer
#  open_issues_count     :integer
#  snapshot_time         :datetime         not null
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

require 'rails_helper'

RSpec.describe CodeClimateProjectMetric, type: :model do
  it { is_expected.to belong_to(:project) }

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
      .with_options(null: false)
  end
end
