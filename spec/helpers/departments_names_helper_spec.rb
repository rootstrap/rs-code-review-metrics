require 'rails_helper'

RSpec.describe DepartmentsNamesHelper, type: :helper do
  describe '.all_department_names' do
    let(:size_of_departments) { 3 }
    before do
      size_of_departments.times do |n|
        create(:project, lang: %w[ruby react android][n - 1])
      end
    end

    it 'returns a departments names collection' do
      expect(helper.all_departments_names).to be_an(Array)
    end

    it 'returns a collection of string' do
      expect(helper.all_departments_names).to include(a_kind_of(String))
    end

    it 'returns all the names of the existing departments' do
      expect(helper.all_departments_names.size).to eq(size_of_departments)
    end
  end
end
