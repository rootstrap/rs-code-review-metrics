class AdminMailer < ApplicationMailer
  def notify_below_rate(alert)
    @alert = alert
    @metric_name = alert.metric_name
    @entity_is_repo = alert.repository.present?

    return unless entity_is_repo || alert.department.present?

    @entity_name = @entity_is_repo ? alert.repository.name : alert.department.name
    mail(to: notify_below_rate_emails, subject: I18n.t('mailer.notify_below_rate.subject'))
  end

  def notify_below_rate_emails
    @alert.emails || self.class.admin_emails
  end

  def self.admin_emails
    AdminUser.pluck(:email)
  end
end
