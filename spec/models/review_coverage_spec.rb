# == Schema Information
#
# Table name: review_coverages
#
#  id                        :bigint           not null, primary key
#  coverage_percentage       :decimal(, )      not null
#  deleted_at                :datetime
#  files_with_comments_count :integer          not null
#  total_files_changed       :integer          not null
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  pull_request_id           :bigint           not null
#
# Indexes
#
#  index_review_coverages_on_pull_request_id  (pull_request_id)
#
# Foreign Keys
#
#  fk_rails_...  (pull_request_id => events_pull_requests.id)
#

require 'rails_helper'

RSpec.describe ReviewCoverage, type: :model do
  subject { build :review_coverage }

  context 'validations' do
    it 'is valid with valid attributes' do
      expect(subject).to be_valid
    end

    it { is_expected.to validate_presence_of(:total_files_changed) }
    it { is_expected.to validate_presence_of(:files_with_comments_count) }
    it { is_expected.to validate_uniqueness_of(:pull_request_id) }
    it { is_expected.to belong_to(:pull_request) }

    it 'total_files_changed is not valid with negative value' do
      subject.total_files_changed = -1
      expect(subject).not_to be_valid
    end

    it 'files_with_comments_count is not valid with negative value' do
      subject.files_with_comments_count = -1
      expect(subject).not_to be_valid
    end
  end

  describe 'callbacks' do
    describe '#calculate_coverage_percentage' do
      let(:total_files) { 10 }
      let(:files_with_comments) { 5 }
      let(:expected_percentage) { 0.5 }

      before do
        subject.total_files_changed = total_files
        subject.files_with_comments_count = files_with_comments
      end

      it 'calculates the coverage percentage correctly' do
        subject.save!
        expect(subject.coverage_percentage).to eq(expected_percentage)
      end
    end
  end
end
