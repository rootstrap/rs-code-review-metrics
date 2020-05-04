FactoryBot.define do
  factory :blog_post_payload, class: Hash do
    skip_create

    ID { Faker::Number.number(digits: 4) }
    site_ID { 166779230 }
    date { Faker::Date.backward.to_time.iso8601 }
    title { Faker::Marketing.buzzwords }
    URL { Faker::Internet.url(host: 'rootstrap.com/blog') }
    short_URL { Faker::Internet.url(host: 'rootstrap.com/blog') }
    slug { Faker::Internet.slug(glue: '-') }
    status { BlogPost.statuses[:publish] }
    tags { {} }
    categories { {} }

    initialize_with { attributes.deep_stringify_keys }
  end
end
