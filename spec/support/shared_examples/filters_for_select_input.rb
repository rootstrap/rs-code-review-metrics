require 'rails_helper'

RSpec.shared_examples 'models names collection helper' do |method|
  it 'returns a projects names collection' do
    expect(helper.send(method)).to be_an(Array)
  end
end
