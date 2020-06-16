require 'rails_helper'

describe CodeClimate::UpdateAllProjectsService do
  subject { CodeClimate::UpdateAllProjectsService }
  let(:update_all_projects_code_climate_info) { subject.call }

  it 'with no projects does no fail' do
    expect { update_all_projects_code_climate_info }.not_to raise_error
  end

  context 'with a project' do
    let!(:first_project) { create :project }

    it('calls UpdateProjectService on that project') do
      expect(CodeClimate::UpdateProjectService).to receive(:call).once.with(first_project)
      update_all_projects_code_climate_info
    end
  end

  context 'with many projects' do
    let!(:first_project) { create :project }
    let!(:second_project) { create :project }

    it('calls UpdateProjectService on each project') do
      expect(CodeClimate::UpdateProjectService).to receive(:call).once.with(first_project)
      expect(CodeClimate::UpdateProjectService).to receive(:call).once.with(second_project)
      update_all_projects_code_climate_info
    end
  end
end
