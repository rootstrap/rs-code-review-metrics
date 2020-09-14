require 'rails_helper'

RSpec.describe 'Admin::FileIgnoringRules', type: :request do
  include Devise::Test::IntegrationHelpers

  let!(:admin) { create(:admin_user) }

  before { sign_in admin }

  describe '#create' do
    let(:regex) { 'spec/' }
    let(:params) do
      {
        file_ignoring_rule: {
          language_id: language_id,
          regex: regex
        }
      }
    end

    context 'when a language has been specified' do
      let(:language) { Language.first }
      let(:language_id) { language.id }

      it 'creates a new rule for that language' do
        post admin_file_ignoring_rules_path, params: params

        expect(language.file_ignoring_rules.first.regex).to eq regex
      end
    end

    context 'when "all" has been specified' do
      let(:language_id) { nil }
      let(:all_languages) { Language.where.not(name: 'unassigned') }

      it 'creates a new rule for every language except for unassigned' do
        post admin_file_ignoring_rules_path, params: params

        expect(all_languages.map { |language| language.file_ignoring_rules.first.regex })
          .to all(eq(regex))
        expect(Language.unassigned.file_ignoring_rules).to be_empty
      end
    end
  end
end
