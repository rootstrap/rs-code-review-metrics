class AdminMailer < ApplicationMailer
  def notify_below_rate(alert)
    repository = alert.repository
    department = alert.department

    @alert = alert
    @metric_name = alert.metric_name
    @entity_is_repo = repository.present?

    return unless @entity_is_repo || department.present?

    from = ENV['SENDMAIL_USERNAME']
    @entity_name = @entity_is_repo ? repository.name : department.name
    mail(fron: from,
         to: notify_below_rate_emails,
         subject: I18n.t('mailer.notify_below_rate.subject'))
  end

  def notify_below_rate_emails
    @alert.emails.split(',') || self.class.admin_emails
  end

  def self.admin_emails
    AdminUser.pluck(:email)
  end
end
