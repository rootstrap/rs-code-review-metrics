require 'rails_helper'

describe 'Open Source', type: :request do
  describe '#index' do
    let(:language) { projects.first.language }
    let(:project_count) { 1 }
    let!(:projects) { create_list(:project, project_count, :open_source) }

    describe 'projects count' do
      it 'renders the project count per language' do
        get open_source_index_url

        expect(response.body)
          .to include("<b>#{project_count}</b> #{language.name.titleize} project")
      end

      it 'renders the project count totals' do
        get open_source_index_url

        expect(response.body)
          .to include("<b>#{project_count}</b> open source project")
      end

      context 'when the project count is greater than 1' do
        let(:project_count) { 14 }

        it 'pluralizes the word "project"' do
          get open_source_index_url

          expect(response.body)
            .to include("<b>#{project_count}</b> #{language.name.titleize} projects")
          expect(response.body)
            .to include("<b>#{project_count}</b> open source projects")
        end
      end
    end
  end
end
