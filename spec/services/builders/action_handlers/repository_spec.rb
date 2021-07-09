require 'rails_helper'

describe ActionHandlers::Repository do
  describe '.call' do
    let(:payload) { create(:repository_event_payload, action: action) }
    let!(:repository) { create(:repository) }

    subject(:handle_action) { described_class.call(payload: payload, entity: repository) }

    handleable_actions = %w[deleted archived transferred].freeze
    unhandleable_actions = Events::Repository.actions.values - handleable_actions

    context 'when the action is handleable' do
      handleable_actions.each do |action|
        let(:action) { action }

        it 'marks the project as deleted' do
          expect { handle_action }.to change(Project, :count)
          expect(repository.project.deleted?).to be(true)
        end
      end
    end

    context 'when the action is unhandleable' do
      unhandleable_actions.each do |action|
        let(:action) { action }

        it 'does not mark the project as deleted' do
          expect { handle_action }.not_to change(Project, :count)
          expect(repository.project.deleted?).to be(false)
        end
      end
    end
  end
end
