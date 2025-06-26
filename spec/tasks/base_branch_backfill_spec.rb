require 'rails_helper'
require 'rake'

# rubocop:disable RSpec/DescribeClass
RSpec.describe 'base_branch:backfill' do
  subject { rake['base_branch:backfill'].invoke }

  let(:rake) { Rake::Application.new }
  let(:repository) { create(:repository) }
  let!(:pull_request_without_base_branch) do
    create(:pull_request, base_branch: nil, repository: repository)
  end
  let!(:event) do
    create(:event,
           name: 'pull_request',
           handleable: pull_request_without_base_branch,
           repository: repository,
           data: {
             'pull_request' => {
               'base' => { 'ref' => 'main' },
               'head' => { 'ref' => 'feature-branch' }
             }
           })
  end

  before do
    Rake.application = rake
    Rake::Task.define_task(:environment)
    load 'lib/tasks/base_branch_backfill.rake'
  end

  it 'updates pull requests without base_branch' do
    expect { subject }.to change {
      pull_request_without_base_branch.reload.base_branch
    }.from(nil).to('main')
  end

  context 'when pull request already has base_branch' do
    let!(:pull_request_with_base_branch) do
      create(:pull_request, base_branch: 'develop', repository: repository)
    end

    it 'does not update pull requests that already have base_branch' do
      expect { subject }.not_to change {
        pull_request_with_base_branch.reload.base_branch
      }
    end
  end

  context 'when event data does not contain base branch info' do
    let!(:pull_request_without_data) do
      create(:pull_request, base_branch: nil, repository: repository)
    end
    let!(:event_without_data) do
      create(:event,
             name: 'pull_request',
             handleable: pull_request_without_data,
             repository: repository,
             data: {
               'pull_request' => {
                 'head' => { 'ref' => 'feature-branch' }
               }
             })
    end

    it 'does not update pull request without proper data' do
      expect { subject }.not_to change {
        pull_request_without_data.reload.base_branch
      }
    end
  end
end
# rubocop:enable RSpec/DescribeClass
