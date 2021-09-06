require 'rails_helper'

RSpec.describe ModelsNamesHelper, type: :helper do
  let(:size_of_models_to_create) { 3 }

  describe '.all_repositories_names' do
    let!(:rs_site_django_repository) do
      create(:repository, name: 'rs-site-django', language: Language.find_by(name: 'python'))
    end
    let!(:elon1_raspberry_repository) do
      create(:repository, name: 'elon1-raspberry', language: Language.find_by(name: 'python'))
    end
    let!(:champz_api_research_repository) do
      create(:repository, name: 'champz-api-research', language: Language.find_by(name: 'nodejs'))
    end

    it_behaves_like 'models names collection helper', 'all_repositories_names'

    it 'returns a collection of string' do
      expect(helper.all_repositories_names).to include(a_kind_of(String))
    end

    it 'returns all the names of the existing repositories plus the base option to select' do
      expect(helper.all_repositories_names.size).to eq(size_of_models_to_create)
    end

    it 'returns the champz-api-research as first repository in the collection' do
      expect(helper.all_repositories_names.first).to eq(champz_api_research_repository.name)
    end
    it 'returns the elon1_raspberry_repository as second repository in the collection' do
      expect(helper.all_repositories_names.second).to eq(elon1_raspberry_repository.name)
    end
    it 'returns the rs-site-django as third repository in the collection' do
      expect(helper.all_repositories_names.third).to eq(rs_site_django_repository.name)
    end

    context 'when one of the repository names start with an uppercase' do
      let!(:elon1_raspberry_repository) do
        create(:repository, name: 'Elon1-raspberry', language: Language.find_by(name: 'python'))
      end

      it 'still places it in the correct position' do
        expect(helper.all_repositories_names.second).to eq(elon1_raspberry_repository.name)
      end
    end
  end

  describe '.all_users_names' do
    before { create_list(:user, size_of_models_to_create) }
    let(:collection_names_size_plus_base_option) { size_of_models_to_create + 1 }

    it_behaves_like 'models names collection helper', 'all_users_names'

    it 'returns all the names of the existing repositories plus the base option to select' do
      expect(helper.all_users_names.size).to eq(collection_names_size_plus_base_option)
    end
  end

  describe '.all_departments_names' do
    it_behaves_like 'models names collection helper', 'all_departments_names'

    it 'returns a collection of string' do
      expect(helper.all_departments_names).to include(a_kind_of(String))
    end

    it 'returns all the names of the existing departments' do
      expect(helper.all_departments_names.size).to eq(size_of_models_to_create)
    end
  end

  describe '.all_languages_names' do
    let(:department) { Department.first }

    it 'returns a collection of [name, id] to use in a drop down list' do
      expect(helper.all_languages_names(department)).to eq(%w[ruby nodejs python])
    end
  end
end
