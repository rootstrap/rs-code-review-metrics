require 'rails_helper'

RSpec.describe GithubReposApi do
  describe '#get_content_of_file' do
    context 'when the project or the file is not found' do
      before { stub_get_content_of_file_not_found }
      it 'returns an empty hash' do
        expect(described_class.new('new_project').get_content_of_file('CODEOWNERS'))
          .to eq({})
      end
    end
  end
end
