# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
if Rails.env.development?
  AdminUser.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password')

  project = FactoryBot.create(:project, name: 'rs-code-review-metrics')

  ['santi_vidal', 'santi_barte', 'hernan', 'horacio', 'hosward', 'sandro'].each do |name|
    FactoryBot.create(:user, login: name)
  end

  User.all.each { |user| UsersProject.create!(user: user, project: project) }

  UsersProject.all.each do |uspr|
    20.times do |v|
      FactoryBot.create(:metric, ownable: uspr, value_timestamp: Time.zone.now - v.days)
    end

    6.times do |v|
      FactoryBot.create(
        :metric,
        interval: :weekly,
        ownable: uspr,
        value_timestamp: (Time.zone.now - v.weeks).beginning_of_week
      )
    end

    6.times do |v|
      FactoryBot.create(
        :metric,
        interval: :weekly,
        ownable: uspr,
        value_timestamp: (Time.zone.now - v.weeks).beginning_of_week
      )
    end
  end

  Technology.create_with(keyword_string: 'ruby,rails').find_or_create_by!(name: 'ruby')
  Technology.create_with(keyword_string: 'python,django').find_or_create_by!(name: 'python')
  Technology.create_with(keyword_string: '').find_or_create_by!(name: 'other')
end
