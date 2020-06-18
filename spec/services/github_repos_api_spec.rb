require 'rails_helper'

RSpec.describe GithubReposApi do
  describe '#get_content_of_file' do
    context 'when the project or the file is not found' do
      before { stub_get_content_from_file_not_found }
      it 'returns an empty string' do
        expect(described_class.new('rs-code-metrics').get_content_from_file('CODEOWNERS'))
          .to eq('')
      end
    end

    context 'when the project or the file is found' do
      before { stub_get_content_from_file_ok }
      it 'returns a string with the codeowners as mentions' do
        expect(described_class.new('rs-code-metrics').get_content_from_file('CODEOWNERS'))
          .to include('@santiagovidal')
      end
    end
  end
end
