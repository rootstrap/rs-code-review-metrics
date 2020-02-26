# == Schema Information
#
# Table name: events
#
#  id              :bigint           not null, primary key
#  data            :jsonb
#  handleable_type :string
#  name            :string
#  type            :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  handleable_id   :bigint
#  project_id      :bigint           not null
#
# Indexes
#
#  index_events_on_handleable_type_and_handleable_id  (handleable_type,handleable_id)
#  index_events_on_project_id                         (project_id)
#

require 'rails_helper'

RSpec.describe Event, type: :model do
  subject { build :event }

  context 'validations' do
    it { should validate_presence_of(:name) }
    it {
      should validate_inclusion_of(:name)
        .in_array(%w[pull_request review review_comment])
    }

    it { should validate_presence_of(:data) }
  end
end
