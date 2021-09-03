require 'rails_helper'

describe Processors::CodeClimateUpdateAllRepositoriesService do
  subject { Processors::CodeClimateUpdateAllRepositoriesService }
  let(:update_all_repositories_code_climate_info) { subject.call }

  it 'with no repositories it does not fail' do
    expect { update_all_repositories_code_climate_info }.not_to raise_error
  end

  context 'with a repository' do
    let!(:first_repository) { create :repository }

    it('calls UpdateRepositoryService on that repository') do
      expect(CodeClimate::UpdateRepositoryService).to receive(:call).once.with(first_repository)
      update_all_repositories_code_climate_info
    end
  end

  context 'with many repositories' do
    let!(:first_repository) { create :repository }
    let!(:second_repository) { create :repository }

    it('calls UpdateRepositoryService on each repository') do
      expect(CodeClimate::UpdateRepositoryService).to receive(:call).once.with(first_repository)
      expect(CodeClimate::UpdateRepositoryService).to receive(:call).once.with(second_repository)
      update_all_repositories_code_climate_info
    end
  end
end
