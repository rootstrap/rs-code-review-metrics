# == Schema Information
#
# Table name: technologies
#
#  id             :bigint           not null, primary key
#  keyword_string :text
#  name           :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
require 'rails_helper'

RSpec.describe Technology, type: :model do
  describe '#keywords' do
    let(:keyword_1) { 'ruby' }
    let(:keyword_2) { 'rails' }
    let(:keywords) { [keyword_1, keyword_2] }
    let(:keyword_string) do
      keywords.reduce { |string, keyword| string + ",#{keyword}" }
    end
    let(:technology) { create(:technology, keyword_string: keyword_string) }

    it 'returns the keyword_string as an array of keywords' do
      expect(technology.keywords).to match_array keywords
    end
  end
end
