require 'rails_helper'

describe ProductService do
  let(:product) { create(:product) }
  let(:projects) { create_list(:project, 2) }
  let(:jira_project) { create(:jira_project, product: product) }

  let!(:params) do
    {
      name: product.name,
      description: product.description,
      jira_project_attributes: {
        id: jira_project.id,
        jira_project_key: jira_project.jira_project_key
      },
      project_ids: projects.first.id
    }
  end

  describe '#update' do
    subject { ProductService.new(product).update!(params) }

    context 'when adding projects to a product' do
      it 'add the project to the product' do
        subject
        expect(product.projects.count).to eq(1)
      end

      it 'creates the association between the product and the project' do
        subject
        expect(product.projects.first).to eq(projects.first)
      end

      it 'does not add other projects of the system' do
        subject
        expect(product.projects).not_to include(projects.last)
      end
    end

    context 'when removing projects to a product' do
      it 'removes the association between the product and the project' do
        params[:project_ids] = []
        product.projects = projects

        subject
        expect(product.projects).to be_empty
      end
    end
  end
end
