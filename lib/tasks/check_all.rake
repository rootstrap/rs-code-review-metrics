task check_all: :environment do
  run('bundle exec brakeman . -z -q', expected_output: 'No warnings found')
  run('bundle exec rubocop -a app config lib spec', expected_output: 'no offenses detected')
  run('bundle exec reek app config lib spec', expected_output: '0 total warnings')
  run('bundle exec rails_best_practices .', expected_output: 'No warning found. Cool!')
  system('rspec')
end

def run(command, expected_output:)
  `#{command}`.tap do |output|
    puts output unless output.include?(expected_output)
  end
end
