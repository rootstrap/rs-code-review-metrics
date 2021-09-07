require 'rails_helper'

describe Processors::CodeClimateUpdateAllProjectsService do
  subject { Processors::CodeClimateUpdateAllProjectsService }
  let(:update_all_projects_code_climate_info) { subject.call }

  it 'with no repositories it does not fail' do
    expect { update_all_projects_code_climate_info }.not_to raise_error
  end

  context 'with a repository' do
    let!(:first_repository) { create :repository }

    it('calls UpdateProjectService on that repository') do
      expect(CodeClimate::UpdateProjectService).to receive(:call).once.with(first_repository)
      update_all_projects_code_climate_info
    end
  end

  context 'with many repositories' do
    let!(:first_repository) { create :repository }
    let!(:second_repository) { create :repository }

    it('calls UpdateProjectService on each repository') do
      expect(CodeClimate::UpdateProjectService).to receive(:call).once.with(first_repository)
      expect(CodeClimate::UpdateProjectService).to receive(:call).once.with(second_repository)
      update_all_projects_code_climate_info
    end
  end
end
