require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module GithubAnalyzer
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    # Generates a "structure.sql" and allow raw sql
    config.active_record.schema_format = :sql
    # Autoload lib folder
    config.autoload_paths << "#{Rails.root}/lib"

    config.action_mailer.smtp_settings = {
      user_name: ENV['SENDMAIL_USERNAME'],
      password: ENV['SENDMAIL_PASSWORD'],
      domain: ENV['MAIL_HOST'],
      address: 'smtp.gmail.com',
      port: '587',
      authentication: :plain,
      enable_starttls_auto: true
    }

    config.action_mailer.perform_caching = false
    config.action_mailer.perform_deliveries = true
    config.action_mailer.raise_delivery_errors = true
    config.action_mailer.default_url_options = { host: ENV['ENGINEERING_METRICS_URL'] }
    config.action_mailer.delivery_method = :smtp
    config.action_mailer.default_options = {
      from: "Engineering Metrics <#{ENV['SENDMAIL_USERNAME']}>"
    }
  end
end
