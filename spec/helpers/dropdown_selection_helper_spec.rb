require 'rails_helper'

RSpec.describe DropdownSelectionHelper, type: :helper do
  describe '.value_from_query_param' do
    it 'returns the period value in the request parameters' do
      controller.params[:metric] = { period: 'weekly' }
      expect(helper.value_from_query_param(:period)).to eq('weekly')
    end
  end
end
