# == Schema Information
#
# Table name: alerts
#
#  id            :bigint           not null, primary key
#  active        :boolean
#  emails        :string
#  frequency     :integer
#  metric_name   :string
#  name          :string
#  start_date    :datetime
#  threshold     :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  department_id :bigint
#  repository_id :bigint
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
  validates :emails, format: { with: /([^,]+)/, message: I18n.t('alerts.emails_split_by_comma') }

  validate :department_or_repository_presence

  def department_or_repository_presence
    return unless repository.blank? && department.blank?

    errors.add(:department_or_repository_presence,
               I18n.t('alerts.department_or_repository_presence'))
  end
end
