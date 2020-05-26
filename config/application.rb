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

    config.hosts << ENV.fetch('HEROKU_URL', '')
    config.hosts << 'www.example.com'
  end
end
