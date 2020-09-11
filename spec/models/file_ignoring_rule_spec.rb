# == Schema Information
#
# Table name: file_ignoring_rules
#
#  id          :bigint           not null, primary key
#  regex       :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  language_id :bigint           not null
#
# Indexes
#
#  index_file_ignoring_rules_on_language_id  (language_id)
#
# Foreign Keys
#
#  fk_rails_...  (language_id => languages.id)
#

require 'rails_helper'

RSpec.describe FileIgnoringRule, type: :model do
  context 'validations' do
    subject { build :file_ignoring_rule }

    it { is_expected.to belong_to(:language) }

    it 'is not valid without a regex' do
      subject.regex = nil
      expect(subject).not_to be_valid
    end
  end
end
