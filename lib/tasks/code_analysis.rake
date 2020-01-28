task code_analysis: :environment do
  sh 'bundle exec brakeman . -z -q'
  sh 'bundle exec rubocop app config lib spec'
  sh 'bundle exec reek app config lib'
  sh 'bundle exec rails_best_practices .'
end
