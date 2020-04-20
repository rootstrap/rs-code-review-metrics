FactoryBot.define do
  factory :users_project do
    association :user
    association :project
  end
end
