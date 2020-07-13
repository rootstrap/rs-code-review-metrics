require 'rails_helper'
require 'rake'

describe 'running the rake task projects:update_privacy' do
  let(:load_rake_projects) do
    Rake.application.rake_require 'tasks/projects'
    Rake::Task.define_task(:environment)
  end

  let(:rake_update_projects_privacy) do
    Rake.application.invoke_task 'projects:update_privacy'
  end

  before do
    load_rake_projects
  end

  it 'calls the ProjectPrivacyBackfiller processor' do
    expect(Processors::ProjectPrivacyBackfiller).to receive(:call)

    rake_update_projects_privacy
  end
end
