require 'rails_helper'

RSpec.shared_examples 'models names collection helper' do |method|
  it 'returns a projects names collection' do
    expect(helper.send(method)).to be_an(Array)
  end

  it 'returns all the names of the existing projects plus the base option to select' do
    expect(helper.send(method).size).to eq(collection_names_size_plus_base_option)
  end
end
