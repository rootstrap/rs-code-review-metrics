require 'rails_helper'

RSpec.describe Setting, type: :model do
  subject { build :setting }

  it { is_expected.to validate_uniqueness_of(:key) }
end
