# Project payload
FactoryBot.define do
  factory :repository_payload, class: Hash do
    skip_create

    id { Faker::Number.number(digits: 4) }
    name { Faker::App.name }
    description { '' }
    private { false }
    archived { false }
    html_url { 'https://github.com/Codertocat/Hello-World' }
    owner do
      {
        login: Faker::Name.name.gsub(' ', '')
      }
    end

    initialize_with { attributes.deep_stringify_keys }

    after(:build) do |repository_payload|
      owner = repository_payload['owner']['login']
      repository_name = repository_payload['name']
      repository_payload['full_name'] = "#{owner}/#{repository_name}"
    end
  end

  factory :repository_event_payload, class: Hash do
    skip_create

    action { Events::Repository.actions.values.sample }
    html_url { Faker::Internet.url(host: 'github.com') }
    repository { create(:repository_payload) }
    sender { (attributes_for :user, id: generate(:user_id)).as_json }

    initialize_with { attributes.deep_stringify_keys }
  end
end
