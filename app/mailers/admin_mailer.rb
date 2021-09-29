class AdminMailer < ApplicationMailer
  def notify_below_rate(alert)
    repository = alert.repository
    department = alert.department

    @alert = alert
    @metric_name = alert.metric_name
    @entity_is_repo = repository.present?

    return unless @entity_is_repo || department.present?

    from = ENV['SENDGRID_USERNAME']
    @entity_name = @entity_is_repo ? repository.name : department.name

    mail(from: from,
         to: @alert.emails,
         subject: I18n.t('mailer.notify_below_rate.subject'))
  end
end
