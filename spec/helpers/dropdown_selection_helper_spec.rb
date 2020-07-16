require 'rails_helper'

RSpec.describe DropdownSelectionHelper, type: :helper do
  describe '.chosen_period' do
    context 'when period value is present' do
      it 'returns the period value from request parameters' do
        controller.params[:metric] = { period: 5 }
        expect(helper.chosen_period).to eq(5)
      end
    end
    context 'when period value is not preset' do
      it 'returns 4 as default value' do
        controller.params[:metric] = {}
        expect(helper.chosen_period).to eq(4)
      end
    end
  end

  describe '.chosen_user' do
    it 'returns the user name from the id on the request parameters' do
      controller.params[:id] = '4'
      expect(helper.chosen_user).to eq('4')
    end
  end
end
