require 'rails_helper'

RSpec.describe Builders::Departments::Projects::ByRelevance do
  describe '.call' do
    let(:ruby_project_1) do
      create(:project, relevance: 'internal', language: Language.find_by(name: 'ruby'))
    end
    let(:ruby_project_2) do
      create(:project, relevance: 'commercial', language: Language.find_by(name: 'ruby'))
    end
    let(:node_project_1) do
      create(:project, relevance: 'internal', language: Language.find_by(name: 'nodejs'))
    end
    let(:node_project_2) do
      create(:project, relevance: 'commercial', language: Language.find_by(name: 'nodejs'))
    end
    let(:python_project_1) do
      create(:project, relevance: 'internal', language: Language.find_by(name: 'python'))
    end
    let(:python_project_2) do
      create(:project, relevance: 'commercial', language: Language.find_by(name: 'python'))
    end

    context 'when projects are filtered by activity' do
      subject do
        described_class.call(
          department: Department.find_by(name: 'backend'),
          from: 4
        )
      end

      it 'returns ruby projects' do
        expect(subject).to have_key('ruby')
      end

      it 'returns nodejs projects' do
        expect(subject).to have_key('nodejs')
      end

      it 'returns python projects' do
        expect(subject).to have_key('python')
      end

      context 'when there are internal projects' do
        it 'returns ruby projects' do
          expect(subject[:ruby]).to have_key('internal')
        end

        it 'returns ruby projects' do
          expect(subject[:nodejs]).to have_key('internal')
        end

        it 'returns ruby projects' do
          expect(subject[:python]).to have_key('internal')
        end
      end

      context 'when there are commercial projects' do
        it 'returns ruby projects' do
          expect(subject[:ruby]).to have_key('commercial')
        end

        it 'returns ruby projects' do
          expect(subject[:nodejs]).to have_key('commercial')
        end

        it 'returns ruby projects' do
          expect(subject[:python]).to have_key('commercial')
        end
      end
    end
  end
end
