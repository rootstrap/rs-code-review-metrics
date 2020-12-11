require 'rails_helper'

RSpec.describe Builders::Chartkick::Helpers::SuccessRate do
  describe '.call' do
    let(:department_name) { 'backend' }
    let(:metric_name) { 'merge_time' }
    let(:setting_name) { Setting::SUCCESS_PREFIX + '_' + department_name + '_' + metric_name }
    let(:intervals) do
      [['1-12', 1], ['12-24', 1], ['24-36', 1], ['36-48', 1],
       ['48-60', 1], ['60-72', 1], ['72+', 1]]
    end

    let(:subject) { described_class.call(department_name, metric_name, intervals) }

    it 'returns total of items' do
      expect(subject[:total]).to eq 7
    end

    context 'when success rate time limit is set for given metric and department' do
      let(:setting_value) { '36' }
      let!(:success_rate_setting) do
        create(:setting,
               key: setting_name,
               value: setting_value)
      end

      it 'returns items matching time limit' do
        expect(subject[:successful]).to eq 3
      end

      it 'returns metric setting name' do
        expect(subject[:metric_detail][:name]).to eq setting_name
      end

      it 'returns metric setting value' do
        expect(subject[:metric_detail][:value]).to eq setting_value.to_i
      end
    end

    context 'when success rate time limit is not set for given metric and department' do
      it 'returns items matching default time limit of 24 hours' do
        expect(subject[:successful]).to eq 2
      end

      it 'returns metric setting name' do
        expect(subject[:metric_detail][:name]).to eq setting_name
      end

      it 'returns time limit default value' do
        expect(subject[:metric_detail][:value]).to eq 24
      end
    end

    it 'returns successful rate' do
      expect(subject[:rate]).to eq 28
    end
  end
end
