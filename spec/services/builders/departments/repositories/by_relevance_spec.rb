require 'rails_helper'

RSpec.describe Builders::Departments::Repositories::ByRelevance do
  describe '.call' do
    let(:ruby_repository_1) do
      create(:repository, relevance: 'internal', language: Language.find_by(name: 'ruby'))
    end
    let(:ruby_repository_2) do
      create(:repository, relevance: 'commercial', language: Language.find_by(name: 'ruby'))
    end
    let(:node_repository_1) do
      create(:repository, relevance: 'internal', language: Language.find_by(name: 'nodejs'))
    end
    let(:node_repository_2) do
      create(:repository, relevance: 'commercial', language: Language.find_by(name: 'nodejs'))
    end
    let(:python_repository_1) do
      create(:repository, relevance: 'internal', language: Language.find_by(name: 'python'))
    end
    let(:python_repository_2) do
      create(:repository, relevance: 'commercial', language: Language.find_by(name: 'python'))
    end

    context 'when repositories are filtered by activity' do
      subject do
        described_class.call(
          department: Department.find_by(name: 'backend'),
          from: 4
        )
      end

      it 'returns ruby repositories' do
        expect(subject).to have_key('ruby')
      end

      it 'returns nodejs repositories' do
        expect(subject).to have_key('nodejs')
      end

      it 'returns python repositories' do
        expect(subject).to have_key('python')
      end

      context 'when there are internal repositories' do
        it 'returns ruby repositories' do
          expect(subject[:ruby]).to have_key('internal')
        end

        it 'returns nodejs repositories' do
          expect(subject[:nodejs]).to have_key('internal')
        end

        it 'returns python repositories' do
          expect(subject[:python]).to have_key('internal')
        end
      end

      context 'when there are commercial repositories' do
        it 'returns ruby repositories' do
          expect(subject[:ruby]).to have_key('commercial')
        end

        it 'returns nodejs repositories' do
          expect(subject[:nodejs]).to have_key('commercial')
        end

        it 'returns python repositories' do
          expect(subject[:python]).to have_key('commercial')
        end
      end
    end
  end
end
