require 'rails_helper'

RSpec.describe ProjectsNamesHelper, type: :helper do
  describe '.all_project_names' do
    let(:size_of_projects) { 10 }

    before { create_list(:project, size_of_projects) }

    it 'returns a projects names collection' do
      expect(helper.all_projects_names).to be_an(Array)
    end

    it 'returns a collection of string' do
      expect(helper.all_projects_names).to include(a_kind_of(String))
    end

    it 'returns all the names of the existing projects' do
      expect(helper.all_projects_names.size).to eq(size_of_projects)
    end
  end
end
