require 'rails_helper'

RSpec.describe DropdownSelectionHelper, type: :helper do
  describe '.chosen_from' do
    context 'when period value is present' do
      it 'returns the period value from request parameters' do
        controller.params[:metric] = { from: Time.zone.now.to_date }
        expect(helper.chosen_from).to eq(Time.zone.now.to_date)
      end
    end
    context 'when period value is not preset' do
      it 'returns initial_from as default value' do
        controller.params[:metric] = {}
        expect(helper.chosen_from).to eq(helper.initial_from)
      end
    end
  end

  describe '.chosen_to' do
    context 'when period value is present' do
      it 'returns the period value from request parameters' do
        controller.params[:metric] = { to: Time.zone.now.to_date }
        expect(helper.chosen_to).to eq(Time.zone.now.to_date)
      end
    end
    context 'when period value is not preset' do
      it 'returns initial_to as default value' do
        controller.params[:metric] = {}
        expect(helper.chosen_to).to eq(helper.initial_to)
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
