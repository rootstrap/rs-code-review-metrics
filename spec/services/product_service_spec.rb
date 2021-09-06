require 'rails_helper'

describe ProductService do
  let(:product) { create(:product) }
  let(:repositories) { create_list(:repository, 2) }
  let(:jira_board) { create(:jira_board, product: product) }

  let!(:params) do
    {
      name: product.name,
      description: product.description,
      jira_board_attributes: {
        id: jira_board.id,
        jira_project_key: jira_board.jira_project_key
      },
      repository_ids: repositories.first.id
    }
  end

  describe '#update' do
    subject { ProductService.new(product).update!(params) }

    context 'when adding repositories to a product' do
      it 'add the repository to the product' do
        subject
        expect(product.repositories.count).to eq(1)
      end

      it 'creates the association between the product and the repository' do
        subject
        expect(product.repositories.first).to eq(repositories.first)
      end

      it 'does not add other repositories of the system' do
        subject
        expect(product.repositories).not_to include(repositories.last)
      end
    end

    context 'when removing repositories to a product' do
      it 'removes the association between the product and the repository' do
        params[:repository_ids] = []
        product.repositories = repositories

        subject
        expect(product.repositories).to be_empty
      end
    end
  end
end
