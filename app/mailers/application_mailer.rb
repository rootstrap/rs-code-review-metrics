class ApplicationMailer < ActionMailer::Base
  default from: MAIL_DEFAULT_FROM
  layout 'mailer'
end
