require 'rails_helper'

RSpec.describe ModelsNamesHelper, type: :helper do
  let(:size_of_models_to_create) { 3 }

  describe '.all_projects_names' do
    before { create_list(:project, size_of_models_to_create) }

    it_behaves_like 'models names collection helper', 'all_projects_names'

    it 'returns a collection of string' do
      expect(helper.all_projects_names).to include(a_kind_of(String))
    end

    it 'returns all the names of the existing projects plus the base option to select' do
      expect(helper.all_projects_names.size).to eq(size_of_models_to_create)
    end
  end

  describe '.all_users_names' do
    before { create_list(:user, size_of_models_to_create) }
    let(:collection_names_size_plus_base_option) { size_of_models_to_create + 1 }

    it_behaves_like 'models names collection helper', 'all_users_names'

    it 'returns all the names of the existing projects plus the base option to select' do
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
end
