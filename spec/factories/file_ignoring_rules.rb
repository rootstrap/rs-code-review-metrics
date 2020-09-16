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

FactoryBot.define do
  factory :file_ignoring_rule do
    language { Language.first }
    regex { 'spec/' }
  end
end
