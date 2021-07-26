# == Schema Information
#
# Table name: repositories
#
#  id         :bigint           not null, primary key
#  action     :string
#  deleted_at :datetime
#  html_url   :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  project_id :bigint           not null
#  sender_id  :bigint           not null
#
# Indexes
#
#  index_repositories_on_project_id  (project_id)
#  index_repositories_on_sender_id   (sender_id)
#
# Foreign Keys
#
#  fk_rails_...  (project_id => projects.id)
#  fk_rails_...  (sender_id => users.id)
#

require 'rails_helper'

RSpec.describe Events::Repository, type: :model do
  context 'validations' do
    subject { build(:repository) }

    it 'is valid with valid attributes' do
      expect(subject).to be_valid
    end

    it { is_expected.to have_one(:event) }
    it { is_expected.to belong_to(:sender) }
    it { is_expected.to belong_to(:project) }
  end
end
