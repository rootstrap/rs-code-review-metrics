require 'rails_helper'
require 'rake'

RSpec.describe 'running the rake task technologies:backfill' do
  let(:load_rake_technologies) do
    Rake.application.rake_require 'tasks/technologies'
    Rake::Task.define_task(:environment)
  end

  let(:rake_backfill_technologies) do
    Rake.application.invoke_task 'technologies:backfill'
  end

  before do
    load_rake_technologies
  end

  it 'calls the TechnologiesBackfiller processor' do
    expect(Processors::TechnologiesBackfiller).to receive(:call)

    rake_backfill_technologies
  end
end
