require 'rails_helper'

RSpec.describe FiltersHelper, type: :helper do
  let(:size_of_models_to_create) { 3 }
  let(:no_params) { {} }

  describe '.all_projects_names' do
    before { create_list(:project, size_of_models_to_create) }

    it_behaves_like 'filters helper', 'all_projects_names'

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

    it_behaves_like 'filters helper', 'all_users_names'

    it 'returns all the names of the existing projects plus the base option to select' do
      expect(helper.all_users_names.size).to eq(collection_names_size_plus_base_option)
    end
  end

  describe '.all_departments_names' do
    it_behaves_like 'filters helper', 'all_departments_names'

    it 'returns a collection of string' do
      expect(helper.all_departments_names).to include(a_kind_of(String))
    end

    it 'returns all the names of the existing departments' do
      expect(helper.all_departments_names.size).to eq(size_of_models_to_create)
    end
  end

  describe '.language_choices' do
    let(:department) { Department.first }

    it 'returns a collection of [name, id] to use in a drop down list' do
      expect(helper.language_choices(department)).to eq(%w[all ruby ios])
    end
  end

  describe '.period_choices' do
    it 'returns a collection of [periods] to use in a drop down list' do
      expect(helper.period_choices).to eq(
        [any_choice,
         'last week', 'last 2 weeks', 'last 3 weeks',
         'last month', 'last 3 months', 'last 6 months',
         'last year']
      )
    end
  end

  describe '.department_filter?' do
    let(:mobile) { { department_name: 'mobile' } }

    it 'if a department filter is present returns true' do
      allow(helper).to receive(:params).and_return(mobile)
      expect(helper.department_filter?).to be true
    end

    it 'if no department filter is present returns false' do
      allow(helper).to receive(:params).and_return(no_params)
      expect(helper.department_filter?).to be false
    end
  end

  describe '.department_name_filter' do
    let(:mobile) { { department_name: 'mobile' } }

    it 'if a department filter is present returns it' do
      allow(helper).to receive(:params).and_return(mobile)
      expect(helper.department_name_filter).to eq('mobile')
    end

    it 'if no department filter is present returns nil' do
      allow(helper).to receive(:params).and_return(no_params)
      expect(helper.department_name_filter).to be_nil
    end
  end

  describe '.chosen_period' do
    let(:daily) { { period: 'daily' } }

    it 'if a period filter is present returns it' do
      allow(helper).to receive(:params).and_return(daily)
      expect(helper.chosen_period).to eq('daily')
    end

    it 'if no period filter is present returns it' do
      allow(helper).to receive(:params).and_return(no_params)
      expect(helper.chosen_period).to eq('all')
    end
  end

  describe '.chosen_language' do
    let(:ios) { { lang: 'ios' } }

    it 'if a language filter is present returns it' do
      allow(helper).to receive(:params).and_return(ios)
      expect(helper.chosen_language).to eq('ios')
    end

    it 'if no language filter is present returns any' do
      allow(helper).to receive(:params).and_return(no_params)
      expect(helper.chosen_language).to eq('all')
    end
  end

  describe '.filter_url_query' do
    let(:params) do
      {
        department_name: 'mobile',
        metric: { period: 'daily' },
        project_name: 'rs-metrics'
      }
    end

    it 'returns the url query with the current filter' do
      allow(helper).to receive(:params).and_return(params)
      expect(helper.filter_url_query).to eq(params)
    end
  end
end
