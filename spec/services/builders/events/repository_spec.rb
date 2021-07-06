describe Builders::Events::Repository do
  describe '.call' do
    let(:payload) { create(:repository_event_payload) }
    let(:repository_payload) { payload['repository'] }
    let(:user_payload) { payload['sender'] }

    subject { described_class.call(payload: payload) }

    it 'creates a new Repository Event' do
      expect { subject }.to change { Events::Repository.count }.by(1)
    end

    it 'creates or assigns correctly its attributes' do
      expect(subject.html_url).to eq(payload['html_url'])
      expect(subject.action).to eq(payload['action'])
      expect(subject.project.github_id).to eq(repository_payload['id'])
      expect(subject.sender.github_id).to eq(user_payload['id'])
      expect(subject.sender.projects).to include(subject.project)
    end
  end
end
