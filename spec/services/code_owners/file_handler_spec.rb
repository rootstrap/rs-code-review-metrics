require 'rails_helper'

RSpec.describe CodeOwners::FileHandler do
  describe '.call' do
    context 'from a long string' do
      let!(:code_owner_string_from_file) { file_fixture('code_owners_file.txt').read }
      it 'does not take any code owner from commented lines' do
        expect(described_class.call(code_owner_string_from_file)).not_to include('global-owner2')
      end

      it 'takes code owners from lines starting with *' do
        expect(described_class.call(code_owner_string_from_file)).to include('santiagovidal')
      end
    end
  end
end
