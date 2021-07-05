module SlackApiMocker
  def stub_notification_webhook
    stub_request(:post, %r{https://hooks.slack.com.*})
      .to_return(body: [], status: 200)
  end
end
