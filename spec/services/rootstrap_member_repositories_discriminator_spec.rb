require 'rails_helper'

RSpec.describe CompanyMemberRepositoriesDiscriminator do
  let(:rootstrap_member) { create(:user, login: 'santib') }

  let(:rootstrap_member_repository) do
    create(:repository_payload, owner: { login: rootstrap_member.login })
  end

  let(:repositories) do
    create_list(:repository_payload, 4) << rootstrap_member_repository
  end

  let(:serialized_repositories) do
    JSON.parse(repositories.to_json, symbolize_names: true)
  end

  it 'returns repositories where the owner is not a rootstrap member' do
    expect(described_class.call(serialized_repositories).size).to eq(4)
  end

  it 'does not return the roostrap member repository' do
    described_class.call(serialized_repositories).each do |repository|
      expect(repository[:id]).not_to eq(rootstrap_member_repository['id'])
    end
  end
end
