describe Metrics::DefectEscapeRate::PerProject do
  describe '.call' do
    let(:project) { create(:project) }
    let!(:jira_project) { create(:jira_project, project: project) }
    let(:beginning_of_day) { Time.zone.today.beginning_of_day }
    let(:subject) { described_class.call(project.id) }

    context 'when there are bugs for the project' do
      let!(:jira_bugs) do
        create_list(:jira_issue, rand(1..10),
                    :bug,
                    :production,
                    jira_project: jira_project,
                    informed_at: beginning_of_day)
      end

      it 'returns the expected payload' do
        metrics = subject
        metric = metrics.first

        expect(metrics.count).to eq(1)
        expect(metric.ownable_id).to eq(project.id)
        expect(metric.value_timestamp).to eq(beginning_of_day)
        expect(metric.value).to eq(defect_rate: 100,
                                   bugs_by_environment: { 'production' => jira_bugs.count })
      end
    end

    context 'when the project has no bugs in the period' do
      it 'returns an empty array' do
        expect(subject).to be_empty
      end
    end
  end
end
