require 'rails_helper'

describe Processors::CodeClimateUpdater do
  describe '#call' do
    let!(:first_project) { create :project }
    let!(:second_project) { create :project }
    let(:subject) { described_class.call }

    it('calls UpdateProjectService on each project') do
      expect(CodeClimate::Link).to receive(:call).once.with(first_project)
      expect(CodeClimate::Link).to receive(:call).once.with(second_project)
      subject
    end
  end
end
