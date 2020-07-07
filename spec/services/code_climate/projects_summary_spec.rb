require 'rails_helper'

describe CodeClimate::ProjectsSummary do
  describe '.call' do
    let(:department) { create(:department) }

    let(:technologies) { ['react_native'] }
    it 'xxx' do
      described_class.call(department: department, technologies: technologies)
    end
  end
end
