# == Schema Information
#
# Table name: external_projects
#
#  id          :bigint           not null, primary key
#  description :string
#  full_name   :string           not null
#  name        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  github_id   :bigint           not null
#  language_id :bigint
#
# Indexes
#
#  index_external_projects_on_language_id  (language_id)
#

require 'rails_helper'

RSpec.describe ExternalProject, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
