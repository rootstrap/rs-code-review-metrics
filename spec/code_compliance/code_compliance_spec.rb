require 'rails_helper'

RSpec.describe 'the source code complies with', code_complience: true do
  let(:brakeman) { `bundle exec brakeman . -z -q` }
  let(:rubocop) { `bundle exec rubocop -a app config lib spec` }
  let(:reek) { `bundle exec reek app config lib spec` }
  let(:rails_best_practices) { `bundle exec rails_best_practices .` }

  it 'brakeman' do
    expect(brakeman).to include('No warnings found')
  end

  it 'rubocop' do
    expect(rubocop).to include('no offenses detected')
  end

  it 'reek' do
    expect(reek).to include('0 total warnings')
  end

  it 'rails_best_practices' do
    expect(rails_best_practices).to include('No warning found. Cool!')
  end
end
