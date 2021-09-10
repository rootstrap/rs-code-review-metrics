module QuickchartApiMocker
  def stub_url_generation(payload, url)
    response_body = {
      'success': 'true',
      'url': url
    }

    stub_request(:post, 'https://quickchart.io/chart/create')
      .with(body: payload.to_json)
      .to_return(
        body: JSON.generate(response_body),
        status: 200
      )
  end

  def stub_failed_url_generation(payload)
    response_body = {
      'success': 'false'
    }

    stub_request(:post, 'https://quickchart.io/chart/create')
      .with(body: payload.to_json)
      .to_return(
        body: JSON.generate(response_body),
        status: 200
      )
  end

  def stub_exception_url_generation(payload)
    stub_request(:post, 'https://quickchart.io/chart/create')
      .with(body: payload.to_json)
      .to_raise(Faraday::ServerError)
  end
end
