require 'rails_helper'

RSpec.describe 'RequestErrorTrackingHelper' do
  class RequestErrorTrackingHelperTestingClass
    include RequestErrorTrackingHelper

    def fail_request(url)
      connection = Faraday.new(url) do |conn|
        conn.response(:raise_error)
      end
      connection.get
    end
  end

  describe '#track_request_error' do
    let(:url) { 'https://failling-api.com' }
    let(:exception) do
      subject.fail_request(url)
    rescue Faraday::BadRequestError => exception
      exception
    end

    subject { RequestErrorTrackingHelperTestingClass.new }

    before { stub_request(:get, url).to_return(status: 400) }

    it 'tracks the request info to Exception Hunter' do
      expect(ExceptionHunter)
        .to receive(:track)
        .with(anything, custom_data: exception.response)

      subject.track_request_error(exception)
    end
  end
end
