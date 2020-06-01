require 'rails_helper'

RSpec.describe Processors::TechnologiesBackfiller do
  describe '#call' do
    it 'creates all the needed technologies' do
      described_class.call

      all_technologies = Technology.pluck(:name)
      expect(all_technologies).to include('ruby')
      expect(all_technologies).to include('python')
      expect(all_technologies).to include('ios')
      expect(all_technologies).to include('android')
      expect(all_technologies).to include('react')
      expect(all_technologies).to include('machine learning')
      expect(all_technologies).to include('other')
    end

    context 'when it has already been run' do
      before { described_class.call }

      it 'does not create new records' do
        expect { described_class.call }.not_to change(Technology, :count)
      end
    end

    context 'when the records in the DB have to be updated' do
      before do
        Technology.create!(name: 'ruby', keyword_string: 'an old keyword string')
      end

      it 'updates the outdated technologies' do
        described_class.call

        expect(Technology.find_by(name: 'ruby').keyword_string).to eq 'ruby,rails'
      end
    end
  end
end
