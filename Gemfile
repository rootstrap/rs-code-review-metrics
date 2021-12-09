source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '~> 2.7.2'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 6.0.3.7'
# Use Puma as the app server
gem 'puma', '~> 5.2.1'
# Use SCSS for stylesheets
gem 'sass-rails', '>= 6'

gem 'webpacker', '~> 5.1', '>= 5.1.1'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.7'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
gem 'pg', '~> 1.2.3'
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Active Storage variant
# gem 'image_processing', '~> 1.2'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.2', require: false

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

gem 'annotate', '~> 3.0'

# Use Sidekiq to enqueue job in the background
gem 'sidekiq', '~> 6.2.1'

gem 'activeadmin', '~> 2.7'
gem 'devise', '~> 4.7.1'

gem 'dotenv-rails', '~> 2.7.5'

gem 'bootstrap', '~> 5.1', '>= 5.1.3'
gem 'jquery-rails', '~> 4.3', '>= 4.3.5'
gem 'simple_form', '~> 5.0', '>= 5.0.2'

gem 'chartkick', '~> 3.4'

gem 'sidekiq-cron', '~> 1.1'

gem 'rails_performance', '~> 0.9.1'

gem 'honeybadger', '~> 4.0'

gem 'exception_hunter', '~> 0.4.1'

gem 'faraday', '~> 1.1', '>= 1.1.0'
gem 'rack-mini-profiler', '~> 2.0'

gem 'groupdate', '~> 5.0'

gem 'slack-notifier', '~> 2.3', '>= 2.3.2'

gem 'acts_as_paranoid', '~> 0.7.0'

gem 'sendgrid-ruby', '~> 6.5.1'

group :development, :test do
  gem 'brakeman', '~> 5.0.0'
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'colorize', '~> 0.8.1'
  gem 'factory_bot_rails', '~> 5.1'
  gem 'faker', '~> 2.10', '>= 2.10.2'
  gem 'letter_opener', '~> 1.7.0'
  gem 'pry-rails', '~> 0.3.9'
  gem 'rspec-collection_matchers', '~> 1.2.0'
  gem 'rspec-rails', '4.0.0.beta3'
end

group :development do
  gem 'rails_best_practices', '~> 1.19.4'
  gem 'reek', '~> 5.5'
  gem 'rubocop-rails', '~> 2.3', '>= 2.3.2'
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'web-console', '>= 3.3.0'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 2.15'
  gem 'fakeredis', '~> 0.8.0', require: 'fakeredis/rspec'
  gem 'selenium-webdriver'
  # Easy installation and use of web drivers to run system tests with browsers
  gem 'rails-controller-testing'
  gem 'shoulda-matchers', '~> 4.2.0', require: false
  gem 'simplecov', require: false
  gem 'stub_env', '~> 1.0'
  gem 'webdrivers'
  gem 'webmock', '~> 3.8'
end
