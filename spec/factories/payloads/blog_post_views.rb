FactoryBot.define do
  factory :blog_post_views_payload, class: Hash do
    skip_create

    transient do
      blog_post { create(:blog_post_payload) }
    end

    date { Time.zone.today }

    years do
      blog_post_date = Time.iso8601(blog_post['date']).to_date
      today = Time.zone.today
      years_hash = {}
      (blog_post_date.year..today.year).each do |year|
        years_hash[year] = { 'months' => {} }
      end
      (blog_post_date..today).map(&:beginning_of_month).uniq.each do |beginning_of_month|
        years_hash[beginning_of_month.year]['months'][beginning_of_month.month] =
          Faker::Number.number(digits: 3)
      end
      years_hash
    end

    initialize_with { attributes.deep_stringify_keys }

    after(:build) do |blog_post_views_payload|
      blog_post_views_payload['years'].each do |_year, year_hash|
        year_hash['total'] = year_hash['months'].values.sum
      end

      blog_post_views_payload['views'] = blog_post_views_payload['years'].sum do |_year, year_hash|
        year_hash['total']
      end
    end
  end
end
