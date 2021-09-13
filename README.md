Code Review Metrics   [![Travis Build](https://travis-ci.com/rootstrap/rs-code-review-metrics.svg?branch=develop)](https://travis-ci.com/rootstrap/rs-code-review-metrics) [![CodeClimate Maintainability](https://api.codeclimate.com/v1/badges/bc6808c1200913bcb29c/maintainability)](https://codeclimate.com/github/rootstrap/rs-code-review-metrics/maintainability) [![CodeClimate Coverage](https://api.codeclimate.com/v1/badges/bc6808c1200913bcb29c/test_coverage)](https://codeclimate.com/github/rootstrap/rs-code-review-metrics/test_coverage)
=========

## Features

This project comes with:
- Administration panel for users
- Rspec tests
- Code quality tools
- Exception Tracking (Exception Hunter https://github.com/rootstrap/exception_hunter)

## How to use

1. Clone this repo
1. Install PostgreSQL in case you don't have it
1. Create `.env` file with env variables and `database.yml`
1. Create DB tables and seed data `rake db:create` `rake db:migrate` `rake db:seed`
1. Install dependencies: `yarn` or `npm install`
1. `rspec` and make sure all tests pass
1. `rails s`

**IMPORTANT: At the moment of running the tests**

1. You will need to have redis installed.

On Mac:
```
brew install redis
brew services start redis
```

2. You'll need SUPERUSER permissions on postgresql for the defined user.

Either assign superuser permissions to `postgres` or update the env vars: `GITHUB_ANALYZER_USERNAME` and `GITHUB_ANALYZER_PASSWORD`
## Tasks
- `rake code_climate:link` is run only to update repositories' Code Climate repository ids.

## Scheduled tasks
- `blog_metrics_partial_update` runs at 04:30. (paused by now)
- `blog_metrics_full_update` runs at 03:00 on day-of-month 1.
- `blog_posts_partial_update` runs at 04:00 every Wednesday.
- `blog_posts_full_update` runs at 02:00 on day-of-month 1.
- `code_owners_list` runs at 23:00 on every day-of-week from Monday through Friday.
- `code_climate_metrics_update` runs at minute 0.
- `external_contributions_processor` runs at 05:00 on every day-of-week from Monday through Friday.
- `jira_defect_metrics_updater` runs at 06:00 on every day-of-week from Monday through Friday.
- `open_source_metrics_update` runs at 06:00.
- `organization_members_updater` runs at 05:00 on every day-of-week from Monday through Friday.
- `send_open_source_notification` runs at 10:00 every Friday.
- `repositories_update` runs at 05:40 every Saturday.

## Settings

### Success Rates Settings
- Department
  - In order to change Department Success Rates time limit setting, create a new `Setting` with key prefix `success_rate`, followed by the department name and the metric name.
  - Example: `Setting.create!(key: 'success_rate_backend_merge_time', value: '12')`
  Possible values: 12 | 24 (default) | 36 | 48 | 60 | 72
- Repository
  - In order to change Repository Success Rates time limit setting, create a new `Setting` with key prefix `success_rate_repository`, followed by repository name the metric name.
  - Example: `Setting.create!(key: 'success_rate_rs-code-review-metrics_merge_time', value: '12')`
  Possible values: 12 | 24 (default) | 36 | 48 | 60 | 72

### Enabled Features Settings
Possible values: true | false (default)

- `enabled_users_section` enables Users section at Development Metrics sidebar.
- `enabled_department_per_tech_graph` enables Department per technology detail graph.
- `enabled_repository_codeowners_section` enables Repository codeowners section.
- `enabled_repository_per_user_graph` enables Repository per-user detail graphs.

## Code quality

With `rake code_analysis` you can run the code analysis tool, you can omit rules with:

- [Rubocop](https://github.com/bbatsov/rubocop/blob/master/config/default.yml) Edit `.rubocop.yml`
- [Reek](https://github.com/troessner/reek#configuration-file) Edit `config.reek`
- [Rails Best Practices](https://github.com/flyerhzm/rails_best_practices#custom-configuration) Edit `config/rails_best_practices.yml`
- [Brakeman](https://github.com/presidentbeef/brakeman) Run `brakeman -I` to generate `config/brakeman.ignore`
- [Bullet](https://github.com/flyerhzm/bullet#whitelist) You can add exceptions to a bullet initializer or in the controller

## Code Coverage
Run `open coverage/index.html` in terminal to see coverage values

## Production

Home Page url: http://engineering-metrics.herokuapp.com/
Exception Hunter dashboard: https://engineering-metrics.herokuapp.com/exception_hunter/errors
Admin: https://engineering-metrics.herokuapp.com/admin
