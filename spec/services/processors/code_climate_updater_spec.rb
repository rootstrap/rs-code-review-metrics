require 'rails_helper'

describe Processors::CodeClimateUpdater do
  describe '#call' do
    let!(:first_repository) { create :repository }
    let!(:second_repository) { create :repository }
    let(:subject) { described_class.call }

    it('calls UpdateProjectService on each repository') do
      expect(CodeClimate::Link).to receive(:call).once.with(first_repository)
      expect(CodeClimate::Link).to receive(:call).once.with(second_repository)
      subject
    end
  end
end
