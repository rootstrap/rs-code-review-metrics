require 'rails_helper'

describe AlertsService do
  shared_examples 'an alert that needs to be triggered' do
    it 'sends an email' do
      allow(AlertsService.new).to receive(:call)

      expect {
        subject
      }.to change(ActionMailer::Base.deliveries, :count).by(1)
    end

    it 'updates last sent date to current day' do
      subject

      expect(alert.reload.last_sent_date). to eq(Time.zone.today)
    end
  end

  shared_examples 'an alert that does not need to be triggered' do
    it 'does not sends an email' do
      allow(AlertsService.new).to receive(:call)

      expect {
        subject
      }.not_to change(ActionMailer::Base.deliveries, :count)
    end
  end

  describe '.search_active_alerts' do
    let(:threshold) { 50 }
    let(:sent_date) { Time.zone.today }

    let!(:alert) do
      create(:alert,
             :with_repository,
             metric_name: 'merge_time',
             active: true,
             threshold: threshold,
             last_sent_date: sent_date,
             frequency: 3)
    end

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
      context 'when execution time is after last sent + frequency' do
        let(:sent_date) { Time.zone.today - 4 }

        it_behaves_like 'an alert that needs to be triggered'
      end

      context 'when execution time is before last sent + frequency' do
        let(:sent_date) { Time.zone.today - 2 }

        it_behaves_like 'an alert that does not need to be triggered'
      end
    end

    context 'when success rate is not below the threshold' do
      let(:threshold) { 15 }

      it_behaves_like 'an alert that does not need to be triggered'
    end
  end
end
