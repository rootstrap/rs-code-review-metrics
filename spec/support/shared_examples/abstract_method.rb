require 'rails_helper'

RSpec.shared_examples 'abstract method' do |method_name, args_count|
  let(:args) { args_count.times.map { anything } }

  it 'is defined' do
    expect(subject.respond_to?(method_name, true)).to eq true
  end

  it 'raises a NoMethodError exception' do
    expect { subject.send(method_name, *args) }.to raise_error NoMethodError
  end
end
