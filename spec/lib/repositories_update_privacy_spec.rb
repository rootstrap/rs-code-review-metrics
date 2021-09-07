require 'rails_helper'
require 'rake'

describe 'running the rake task repositories:update_privacy' do
  let(:load_rake_repositories) do
    Rake.application.rake_require 'tasks/repositories'
    Rake::Task.define_task(:environment)
  end

  let(:rake_update_repositories_privacy) do
    Rake.application.invoke_task 'repositories:update_privacy'
  end

  before do
    load_rake_repositories
  end

  it 'calls the RepositoryPrivacyBackfiller processor' do
    expect(Processors::RepositoryPrivacyBackfiller).to receive(:call)

    rake_update_repositories_privacy
  end
end
