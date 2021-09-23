require 'rails_helper'

describe AlertsService do
  describe '.search_active_alerts' do
    let(:threshold) { 50 }
    let!(:alert) { create(:alert, :with_repository, metric_name: 'merge_time', active: true, threshold: threshold) }

    let(:range) do
      Time.zone.today.beginning_of_week..Time.zone.today.end_of_week
    end

    let(:values_in_seconds) { [108_00, 900_00, 144_000, 198_000, 226_800, 270_000] }

    before do
      values_in_seconds.each do |value|
        pull_request = create(:pull_request, repository: alert.repository, merged_at: Time.zone.now)
        create(:merge_time, pull_request: pull_request, value: value)
      end
    end

    subject { AlertsService.new.call }

    context 'when success rate is below the threshold' do
      it 'sends an email' do
        allow(AlertsService.new).to receive(:call)

        expect {
          subject
        }.to change(ActionMailer::Base.deliveries, :count).by(1)
      end
    end

    context 'when success rate is not below the threshold' do
      let(:threshold) { 15 }
      
      it 'does not sends an email' do
        allow(AlertsService.new).to receive(:call)

        expect {
          subject
        }.not_to change(ActionMailer::Base.deliveries, :count)
      end
    end
  end
end
