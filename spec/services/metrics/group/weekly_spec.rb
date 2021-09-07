require 'rails_helper'

RSpec.describe Metrics::Group::Weekly do
  describe '.call' do
    context 'when querying metrics per department' do
      let(:department) { Department.find_by(name: 'backend') }
      let(:subject) do
        described_class.call(entity_name: 'department', entity_id: department.id,
                             metric_name: 'review_turnaround')
      end

      it 'calls service' do
        expect(Builders::Chartkick::DepartmentData)
          .to receive(:call)
          .with(department.id, any_args)
        subject
      end
    end

    context 'when querying metrics per language' do
      let(:lang) { Language.find_by(name: 'ruby') }
      let(:subject) do
        described_class.call(entity_name: 'language', entity_id: lang.id,
                             metric_name: 'review_turnaround')
      end

      it 'calls service' do
        expect(Builders::Chartkick::LanguageData)
          .to receive(:call)
          .with(lang.id, any_args)
        subject
      end
    end

    context 'when querying metrics per repository' do
      let(:repository) { create(:repository) }
      let(:subject) do
        described_class.call(entity_name: 'repository', entity_id: repository.id,
                             metric_name: 'review_turnaround')
      end

      it 'calls service' do
        expect(Builders::Chartkick::RepositoryData)
          .to receive(:call)
          .with(repository.id, any_args)
        subject
      end
    end

    context 'when querying metrics per user repository' do
      let(:users_repository) { create(:users_repository) }
      let(:subject) do
        described_class.call(entity_name: 'users_repository', entity_id: users_repository.id,
                             metric_name: 'review_turnaround')
      end

      it 'calls service' do
        expect(Builders::Chartkick::UsersRepositoryData)
          .to receive(:call)
          .with(users_repository.id, any_args)
        subject
      end
    end
  end
end
