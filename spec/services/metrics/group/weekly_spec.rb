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
        described_class.call(entity_name: 'project', entity_id: repository.id,
                             metric_name: 'review_turnaround')
      end

      it 'calls service' do
        expect(Builders::Chartkick::ProjectData)
          .to receive(:call)
          .with(repository.id, any_args)
        subject
      end
    end

    context 'when querying metrics per user project' do
      let(:users_project) { create(:users_project) }
      let(:subject) do
        described_class.call(entity_name: 'users_project', entity_id: users_project.id,
                             metric_name: 'review_turnaround')
      end

      it 'calls service' do
        expect(Builders::Chartkick::UsersProjectData)
          .to receive(:call)
          .with(users_project.id, any_args)
        subject
      end
    end
  end
end
