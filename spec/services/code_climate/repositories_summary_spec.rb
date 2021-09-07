require 'rails_helper'

describe CodeClimate::RepositoriesSummary do
  describe '#new' do
    let(:attributes) do
      %w[
        invalid_issues_count_average
        wont_fix_issues_count_average
        open_issues_count_average
        ratings
      ]
    end

    subject do
      described_class.new(
        invalid_issues_count_average: 1,
        wont_fix_issues_count_average: 3,
        open_issues_count_average: 0,
        ratings: { 'A': 1, 'B': 2 }
      )
    end

    it 'has any attribute empty' do
      attributes.each do |attribute|
        expect(subject.send(attribute)).not_to be_nil
      end
    end
  end
end
