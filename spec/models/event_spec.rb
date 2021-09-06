# == Schema Information
#
# Table name: events
#
#  id              :bigint           not null, primary key
#  data            :jsonb
#  deleted_at      :datetime
#  handleable_type :string
#  name            :string
#  type            :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  handleable_id   :bigint
#  repository_id   :bigint           not null
#
# Indexes
#
#  index_events_on_handleable_type_and_handleable_id  (handleable_type,handleable_id)
#  index_events_on_repository_id                      (repository_id)
#
# Foreign Keys
#
#  fk_rails_...  (repository_id => repositories.id)
#

require 'rails_helper'

RSpec.describe Event, type: :model do
  subject { create :event_pull_request }

  context 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:data) }
  end
end
