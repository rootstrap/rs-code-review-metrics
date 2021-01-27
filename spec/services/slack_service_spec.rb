require 'rails_helper'

RSpec.describe SlackService do
  describe '#open_source_reminder' do
    let(:subject) { described_class.open_source_reminder }
    let(:message) do
      I18n.t('services.slack.open_source_reminder.message',
             url: "#{SlackService::ENGINEERING_METRICS_URL}/open_source")
    end

    context 'when sent to valid channel' do
      before { stub_notification_webhook }

      it 'calls Slack Notifier' do
        expect_any_instance_of(Slack::Notifier)
          .to receive(:post)
          .with(text: message, icon_emoji: SlackService::EMOJI)
        subject
      end

      it 'calls Slack API' do
        subject
        expect(WebMock).to have_requested(:post, ENV['SLACK_WEBHOOK_URL']).once
      end

      it 'returns a Slack API successful response' do
        response = subject
        expect(response.first.code.to_i).to eq 200
      end
    end
  end
end
