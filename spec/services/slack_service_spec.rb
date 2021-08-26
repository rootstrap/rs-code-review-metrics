require 'rails_helper'

RSpec.describe SlackService do
  shared_context 'a successful request' do
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

  describe '#open_source_reminder' do
    let(:subject) { described_class.open_source_reminder }
    let(:message) do
      I18n.t('services.slack.open_source_reminder.message',
             url: "#{SlackService::ENGINEERING_METRICS_URL}/open_source")
    end

    context 'when sent to valid channel' do
      before { stub_notification_webhook }

      it_behaves_like 'a successful request'
    end
  end

  describe '#code_climate_error' do
    let(:project) { create(:project) }
    let(:error) { kind_of(Faraday::Error) }

    let(:message) do
      I18n.t('services.slack.code_climate_error.message',
             repository: project.name,
             error: error)
    end

    let(:subject) { described_class.code_climate_error(project, error) }

    context 'when sent to valid channel' do
      before { stub_notification_webhook }

      it_behaves_like 'a successful request'
    end
  end
end
