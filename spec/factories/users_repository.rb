FactoryBot.define do
  factory :users_repository do
    association :user
    association :repository
  end
end
