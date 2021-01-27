require 'rails_helper'

describe OpenSourceSlackJob do
  describe '#perform' do
    before { stub_notification_webhook }

    it 'calls SlackService' do
      expect(SlackService)
        .to receive(:open_source_reminder)
        .once

      described_class.perform_now
    end

    it 'calls Slack API' do
      described_class.perform_now
      expect(WebMock).to have_requested(:post, ENV['SLACK_WEBHOOK_URL']).once
    end
  end
end
