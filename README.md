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
