source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '~> 2.6.3'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 6.0.2'
# Use Puma as the app server
gem 'puma', '~> 4.3'
# Use SCSS for stylesheets
gem 'sass-rails', '>= 6'
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'sprockets', '~> 4'
gem 'sprockets-rails', '~> 3.2', '>= 3.2.1'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.7'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
gem 'pg', '~> 1.1'
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Active Storage variant
# gem 'image_processing', '~> 1.2'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.2', require: false

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

gem 'github_api', '~> 0.18'

gem 'annotate', '~> 3.0'

# Use Sidekiq to enqueue job in the background
gem 'sidekiq', '~> 6.0.2'

gem 'activeadmin', '~> 2.6.0'
gem 'devise', '~> 4.7.1'

gem 'dotenv-rails', '~> 2.7.5'

gem 'bootstrap', '~> 4.4.1'
gem 'jquery-rails', '~> 4.3', '>= 4.3.5'

gem 'chartkick', '~> 3.3', '>= 3.3.1'

gem 'clockwork', '~> 1.2'

group :development, :test do
  gem 'brakeman', '~> 4.7', '>= 4.7.2'
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'colorize', '~> 0.8.1'
  gem 'factory_bot_rails', '~> 5.1'
  gem 'rspec-collection_matchers', '~> 1.2.0'
  gem 'rspec-rails', '~> 3.9'
  gem 'faker', '~> 2.10', '>= 2.10.2'
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
  gem 'selenium-webdriver'
  # Easy installation and use of web drivers to run system tests with browsers
  gem 'shoulda-matchers', '~> 4.2.0', require: false
  gem 'simplecov', require: false
  gem 'webdrivers'
end
