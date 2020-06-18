require 'rails_helper'

RSpec.describe ModelsNamesHelper, type: :helper do
  let(:size_of_models_to_create) { 10 }
  let(:collection_names_size_plus_base_option) { size_of_models_to_create + 1 }
  describe '.all_projects_names' do
    before { create_list(:project, 10) }

    it_behaves_like 'models names collection helper', 'all_projects_names'

    it 'returns a collection of string' do
      expect(helper.all_projects_names).to include(a_kind_of(String))
    end
  end
  describe '.all_users_names' do
    before { create_list(:user, 10) }

    it_behaves_like 'models names collection helper', 'all_users_names'
  end
end
