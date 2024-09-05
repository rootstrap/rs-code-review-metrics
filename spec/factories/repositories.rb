# == Schema Information
#
# Table name: repositories
#
#  id          :bigint           not null, primary key
#  deleted_at  :datetime
#  description :string
#  is_private  :boolean
#  name        :string
#  relevance   :enum             default("unassigned"), not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  github_id   :integer          not null
#  language_id :bigint
#  product_id  :bigint
#
# Indexes
#
#  index_repositories_on_github_id    (github_id) UNIQUE
#  index_repositories_on_language_id  (language_id)
#  index_repositories_on_product_id   (product_id)
#
# Foreign Keys
#
#  fk_rails_...  (product_id => products.id)
#

FactoryBot.define do
  factory :repository do
    sequence(:github_id, 1000)
    name { Faker::App.name.split.first }
    description { Faker::FunnyName.name }
    language { Language.unassigned }
    is_private { false }
    product

    transient do
      last_activity_in_weeks { 2 }
    end

    trait :open_source do
      language { Language.find_by(name: 'ruby') }
      relevance { Repository.relevances[:internal] }
      is_private { false }
    end

    trait :with_activity do
      after(:build) do |repository, evaluator|
        create(:pull_request, repository: repository,
                              opened_at: evaluator.last_activity_in_weeks.weeks.ago)
      end
    end

    trait :internal do
      relevance { Repository.relevances[:internal] }
    end
  end
end
