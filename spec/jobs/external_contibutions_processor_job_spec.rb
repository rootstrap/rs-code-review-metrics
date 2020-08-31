require 'rails_helper'
require 'sidekiq/testing'

RSpec.describe ExternalContributionsProcessorJob do
  it 'executes external contributions processor' do
    expect(Processors::External::Contributions).to receive(:call)

    described_class.perform_now
  end
end
