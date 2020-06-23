require 'rails_helper'

RSpec.describe DropdownSelectionHelper, type: :helper do
  describe '.value_from_metric_param' do
    it 'returns the period value from request parameters' do
      controller.params[:metric] = { period: 'weekly' }
      expect(helper.value_from_metric_param(:period)).to eq('weekly')
    end
  end

  describe '.value_from_project_param' do
    it 'returns the project name from request parameters' do
      controller.params[:project_name] = 'rs-code-metrics'
      expect(helper.value_from_project_param).to eq('rs-code-metrics')
    end
  end

  describe '.value_from_user_param' do
    it 'returns the user name from the id on the request parameters' do
      controller.params[:id] = '4'
      expect(helper.value_from_user_param).to eq('4')
    end
  end
end
