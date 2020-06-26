require 'rails_helper'

RSpec.shared_examples 'filters helper' do |method|
  it 'returns a projects names collection' do
    expect(helper.send(method)).to be_an(Array)
  end
end
