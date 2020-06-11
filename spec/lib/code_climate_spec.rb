require 'rails_helper'
require 'rake'

RSpec.describe 'running the rake task code_climate:update' do
  before do
    load_code_climate_update
  end

  let(:load_code_climate_update) do
    Rake.application.rake_require 'tasks/code_climate'
    Rake::Task.define_task(:environment)
  end

  let(:rake_code_climate_update) do
    Rake.application.invoke_task 'code_climate:update'
  end

  before do
    load_code_climate_update
  end

  it 'creates a CodeClimate::UpdateAllProjectsService and calls it' do
    expect(CodeClimate::UpdateAllProjectsService).to receive(:call)

    rake_code_climate_update
  end
end
