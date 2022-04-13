# == Schema Information
#
# Table name: alerts
#
#  id             :bigint           not null, primary key
#  active         :boolean          default(FALSE), not null
#  emails         :string           default([]), not null, is an Array
#  frequency      :integer          not null
#  last_sent_date :datetime
#  metric_name    :string           not null
#  name           :string
#  threshold      :integer          not null
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

class Alert < ApplicationRecord
  belongs_to :repository, optional: true
  belongs_to :department, optional: true

  validates :metric_name, :frequency, :threshold, :emails, presence: true
  validate :department_or_repository_presence

  def department_or_repository_presence
    return unless repository.blank? && department.blank?

    errors.add(:department_or_repository_presence,
               I18n.t('alerts.department_or_repository_presence'))
  end
end
