module SlackService
  extend self

  ENGINEERING_METRICS_NOTIFICATIONS = '#engineering-metrics-notifications'.freeze
  OPEN_SOURCE = '#open-source'.freeze
  ENGINEERING_METRICS_URL = ENV['ENGINEERING_METRICS_URL']
  EMOJI = ':wave:'.freeze

  def open_source_reminder
    message = I18n.t('services.slack.open_source_reminder.message',
                     url: "#{ENGINEERING_METRICS_URL}/open_source")
    ping(OPEN_SOURCE, message)
  end

  def code_climate_error(repository, error)
    message = I18n.t('services.slack.code_climate_error.message',
                     repository: repository.name,
                     error: error)

    ping(ENGINEERING_METRICS_NOTIFICATIONS, message)
  end

  private

  def ping(channel, message)
    slack = client(channel)
    slack.post(text: message, icon_emoji: EMOJI)
  end

  def client(channel)
    Slack::Notifier.new ENV['SLACK_WEBHOOK_URL'] do
      defaults channel: channel,
               username: 'rootstrap'
    end
  end
end
