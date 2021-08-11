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
    department = Department.create!(name: 'backend')
    %i[ruby nodejs python].each do |lang|
      Language.create(name: lang, department: department)
    end
    department = Department.create!(name: 'frontend')
    %i[react vuejs].each do |lang|
      Language.create(name: lang, department: department)
    end
    department = Department.create!(name: 'mobile')
    %i[ios android react_native].each do |lang|
      Language.create(name: lang, department: department)
    end
    %i[others unassigned].each do |lang|
      Language.create(name: lang)
    end

    product = Product.create!(name: 'rs-code-review-metrics',
                              description: 'Project for tracking PKIs')

    jira_board = JiraBoard.create!(jira_project_key: 'RSCODE',
                                       project_name: 'rs-code-review-metrics',
                                       product: product)

    project = Project.create!(github_id: rand(1000),
                              name: 'rs-code-review-metrics',
                              language: Language.find_by(name: 'ruby'),
                              product: product)

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

    second_product = Product.create!(name: 'forecast',
                                     description: 'Forecast')

    second_jira_board = JiraBoard.create!(jira_project_key: 'forc',
                                              project_name: 'forecast',
                                              product: second_product)

    second_project = Project.create!(github_id: rand(1000),
                                     name: 'forecast',
                                     language: Language.find_by(name: 'ruby'),
                                     product: second_product)

    %w[juan pedro].each do |name|
      FactoryBot.create(:user, login: name)
    end

    User.all.each { |user| UsersProject.create!(user: user, project: second_project) }

    Technology.create_with(keyword_string: 'ruby,rails').find_or_create_by!(name: 'ruby')
    Technology.create_with(keyword_string: 'python,django').find_or_create_by!(name: 'python')
    Technology.create_with(keyword_string: '').find_or_create_by!(name: 'other')

    FactoryBot.create(:code_climate_project_metric, project: project)
    FactoryBot.create(:code_climate_project_metric, project: second_project)

    User.first(3).each { |user| CodeOwnerProject.create!(user: user, project: project) }

    User.last(2).each { |user| CodeOwnerProject.create!(user: user, project: second_project) }

    santiagovidal = User.find_by(login: 'santiagovidal')
    santib = User.find_by(login: 'santib')
    hernan = User.find_by(login: 'hdamico')
    horacio = User.find_by(login: 'horacio')
    hvilloria = User.find_by(login: 'hvilloria')
    sandro = User.find_by(login: 'sandro')

    # Review turnaround and Second review turnaround
    vita_pr = FactoryBot.create(:pull_request, owner: santiagovidal, project: project)
    vita_rr_santib = FactoryBot.create(:review_request, owner: santiagovidal, project: project, pull_request: vita_pr, reviewer: santib)
    FactoryBot.create(:review, owner: santib, project: project, pull_request: vita_pr, review_request: vita_rr_santib)

    vita_rr_hernan = FactoryBot.create(:review_request, owner: santiagovidal, project: project, pull_request: vita_pr, reviewer: hernan)
    FactoryBot.create(:review, owner: hernan, project: project, pull_request: vita_pr, review_request: vita_rr_hernan)

    # Merge Time
    hvilloria_pr = FactoryBot.create(
      :pull_request,
      owner: hvilloria,
      project: project,
      opened_at: 5.hours.ago,
      merged_at: Time.zone.now
    )
    Builders::MergeTime.call(hvilloria_pr)
    sandro_pr = FactoryBot.create(
      :pull_request,
      owner: sandro,
      project: project,
      opened_at: Time.zone.now - 14.hours,
      merged_at: Time.zone.now
    )
    Builders::MergeTime.call(sandro_pr)
    horacio_pr = FactoryBot.create(
      :pull_request,
      owner: horacio,
      project: project,
      opened_at: Time.zone.now - 27.hours,
      merged_at: Time.zone.now
    )
    Builders::MergeTime.call(horacio_pr)
  end
end
