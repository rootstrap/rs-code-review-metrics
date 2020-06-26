# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
if Rails.env.development?
  ActiveRecord::Base.transaction do
    AdminUser.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password')

    # Departments and Languages
    department = Department.create(name: 'backend')
    %i[ruby nodejs python].each do |lang|
      Language.create(name: lang, department: department)
    end
    department = Department.create(name: 'frontend')
    %i[react vuejs].each do |lang|
      Language.create(name: lang, department: department)
    end
    department = Department.create(name: 'mobile')
    %i[ios android react_native].each do |lang|
      Language.create(name: lang, department: department)
    end
    %i[others unassigned].each do |lang|
      Language.create(name: lang)
    end

    project = Project.create(github_id: rand(1000), name: 'rs-code-review-metrics')

    %w[santiagovidal santib hdamico horacio hvilloria sandro].each do |name|
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
    end

    Project.all.each do |uspr|
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
    end

    Technology.create_with(keyword_string: 'ruby,rails').find_or_create_by!(name: 'ruby')
    Technology.create_with(keyword_string: 'python,django').find_or_create_by!(name: 'python')
    Technology.create_with(keyword_string: '').find_or_create_by!(name: 'other')

    FactoryBot.create(:code_climate_project_metric, project: project)
  end
end
