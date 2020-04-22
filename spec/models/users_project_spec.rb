require 'rails_helper'

RSpec.describe UsersProject, type: :model do
  it { is_expected.to validate_uniqueness_of(:user_id).scoped_to(:project_id) }
end
