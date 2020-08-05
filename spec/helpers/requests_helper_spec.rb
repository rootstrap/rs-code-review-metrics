require 'rails_helper'

RSpec.describe RequestsHelper, type: :helper do
  describe '.content_url' do
    before do
      allow_any_instance_of(ActionDispatch::Request).to receive(:original_url) { request_url }
    end

    context 'when the url matches with the resource given' do
      let(:request_url) { 'http://localhost:3000/development_metrics' }
      it 'returns a match data' do
        expect(helper.content_url('development_metrics').class).to eq(MatchData)
      end
    end
    context 'when the url does not match with the resource given' do
      let(:request_url) { 'http://localhost:3000/tech_blog' }
      it 'returns a nil' do
        expect(helper.content_url('development_metrics')).to be_nil
      end
    end
  end
end
