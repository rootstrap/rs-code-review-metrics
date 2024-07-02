source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '~> 3.3.0'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 7.1', '<= 7.1.3.4'
# Use Puma as the app server
gem 'puma', '~> 6.4', '>= 6.4.2'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 6.0'

gem 'webpacker', '~> 5.4', '>= 5.4.4'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5.2', '>= 5.2.1'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.12'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
gem 'pg', '~> 1.5', '>= 1.5.6'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '~> 1.18', '>= 1.18.3', require: false

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

gem 'annotate', '~> 3.2'

# Use Sidekiq to enqueue job in the background
gem 'sidekiq', '~> 7.2', '>= 7.2.4'
gem 'after_commit_everywhere', '~> 1.4'

gem 'activeadmin', '~> 3.2', '>= 3.2.2'
gem 'devise', '~> 4.9', '>= 4.9.4'

gem 'dotenv-rails', '~> 2.7', '>= 2.7.6'

gem 'bootstrap', '~> 5.3', '>= 5.3.3'
gem 'jquery-rails', '~> 4.6'
gem 'simple_form', '~> 5.3', '>= 5.3.1'

gem 'chartkick', '~> 3.4', '>= 3.4.2'

gem 'sidekiq-cron', '~> 1.12'

gem 'rails_performance', '~> 0.9.9'

gem 'honeybadger', '~> 4.12', '>= 4.12.2'

# TODO: Remove this gem if it's not maintained anymore
# gem 'exception_hunter', '~> 0.4.1'

gem 'faraday', '~> 2.9', '>= 2.9.2'

gem 'rack-mini-profiler', '~> 2.3', '>= 2.3.4'

gem 'groupdate', '~> 5.2', '>= 5.2.4'

gem 'slack-notifier', '~> 2.4'

gem 'acts_as_paranoid', '~> 0.10.0'

gem 'sendgrid-ruby', '~> 6.7'

group :development, :test do
  gem 'brakeman', '~> 6.1', '>= 6.1.2'
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'colorize', '~> 0.8.1'
  gem 'factory_bot_rails', '~> 6.4', '>= 6.4.3'
  gem 'faker', '~> 3.4', '>= 3.4.1'
  gem 'letter_opener', '~> 1.10'
  gem 'pry-rails', '~> 0.3.11'
  gem 'rspec-collection_matchers', '~> 1.2', '>= 1.2.1'
  gem 'rspec-rails', '~> 6.1', '>= 6.1.3'
end

group :development do
  gem 'rails_best_practices', '~> 1.23', '>= 1.23.2'
  gem 'reek', '~> 6.3'
  gem 'rubocop', '~> 1.64', '>= 1.64.1'
  gem 'rubocop-rails', '~> 2.9'
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'listen', '~> 3.9'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.1'
  gem 'web-console', '~> 4.2', '>= 4.2.1'
  gem "better_errors"
  gem "binding_of_caller"
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '~> 3.40'
  gem 'fakeredis', '~> 0.9.2', require: 'fakeredis/rspec'
  gem 'selenium-webdriver'
  # Easy installation and use of web drivers to run system tests with browsers
  gem 'rails-controller-testing'
  gem 'shoulda-matchers', '~> 6.2', require: false
  gem 'simplecov', require: false
  gem 'stub_env', '~> 1.0', '>= 1.0.4'
  gem 'webdrivers'
  gem 'webmock', '~> 3.23', '>= 3.23.1'
end
