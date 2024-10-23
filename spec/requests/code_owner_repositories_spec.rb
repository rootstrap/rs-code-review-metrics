require 'rails_helper'

RSpec.describe 'CodeOwnersRepositoriesController' do
  describe '#index' do
    let(:user) { create(:user) }
    subject { get "/development_metrics/users/#{user.id}/repositories" }
    context 'when a user has not repositories as code owner' do
      before do
        subject
      end

      it_behaves_like 'controller index response'

      it 'returns no repositories' do
        expect(assigns(:repositories)).to be_empty
      end
    end

    context 'when user has repositories as code owner' do
      before do
        create_list(:repository, repositories_count)
        Repository.all.each { |repository| repository.code_owners << user }
        subject
      end

      let(:repositories_count) { 5 }

      it_behaves_like 'controller index response'

      it 'returns the correct number of repositories for that code owner' do
        expect(assigns(:repositories).size).to eq(repositories_count)
      end

      it 'returns the repositories that belongs to that code owner' do
        assigns(:repositories).each do |repository|
          expect(repository.code_owners.include?(user)).to eq(true)
        end
      end
    end
  end
end
