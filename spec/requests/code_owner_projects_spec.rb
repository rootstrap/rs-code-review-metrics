require 'rails_helper'

RSpec.describe 'Code Owner Projects' do
  describe '#index' do
    let(:user) { create(:user) }
    subject { get "/development_metrics/users/#{user.id}/projects" }
    context 'when a user has not projects as code owner' do
      before do
        subject
      end

      it_behaves_like 'controller index response'

      it 'returns no projects' do
        expect(assigns(:projects)).to be_empty
      end
    end

    context 'when user has projects as code owner' do
      before do
        create_list(:project, projects_count)
        Project.all.each { |project| project.code_owners << user }
        subject
      end

      let(:projects_count) { 5 }

      it_behaves_like 'controller index response'

      it 'returns the correct number of projects for that code owner' do
        expect(assigns(:projects).size).to eq(projects_count)
      end

      it 'returns the projects that belongs to that code owner' do
        assigns(:projects).each do |project|
          expect(project.code_owners.include?(user)).to eq(true)
        end
      end
    end
  end
end
