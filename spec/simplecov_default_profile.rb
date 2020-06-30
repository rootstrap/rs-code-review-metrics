SimpleCov.profiles.define 'default' do
  add_group 'Services', 'app/services'
  add_group 'Entities', 'app/models/events'
  add_group 'Models', 'app/models'
  add_group 'Controllers', 'app/controllers'
  add_group 'Jobs', 'app/jobs'
  add_group 'Helpers', 'app/helpers'
  add_filter 'spec'
  add_filter 'config'
  add_filter 'app/admin'
  add_filter 'db/seeds'
end
