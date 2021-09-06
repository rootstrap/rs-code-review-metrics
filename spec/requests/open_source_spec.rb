require 'rails_helper'

describe 'Open Source', type: :request do
  describe '#index' do
    let(:language) { repositories.first.language }
    let(:repository_count) { 1 }
    let!(:repositories) { create_list(:repository, repository_count, :open_source) }

    describe 'repositories count' do
      it 'renders the repository count per language' do
        get open_source_index_url

        expect(response.body)
          .to include("<b>#{repository_count}</b> #{language.name.titleize} project")
      end

      it 'renders the repository count totals' do
        get open_source_index_url

        expect(response.body)
          .to include("<b>#{repository_count}</b> open source project")
      end

      context 'when the repository count is greater than 1' do
        let(:repository_count) { 14 }

        it 'pluralizes the word "repository"' do
          get open_source_index_url

          expect(response.body)
            .to include("<b>#{repository_count}</b> #{language.name.titleize} projects")
          expect(response.body)
            .to include("<b>#{repository_count}</b> open source projects")
        end
      end
    end
  end
end
