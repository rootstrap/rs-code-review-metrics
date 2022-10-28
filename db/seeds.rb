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

    repository = Repository.create!(github_id: rand(1000),
                              name: 'rs-code-review-metrics',
                              language: Language.find_by(name: 'ruby'),
                              product: product)

    %w[santiagovidal santib hdamico horacio hvilloria sandro].each do |name|
      FactoryBot.create(:user, login: name)
    end

    User.all.each { |user| UsersRepository.create!(user: user, repository: repository) }

    UsersRepository.all.each do |uspr|
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

    Repository.all.each do |uspr|
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

    second_repository = Repository.create!(github_id: rand(1000),
                                     name: 'forecast',
                                     language: Language.find_by(name: 'ruby'),
                                     product: second_product)

    %w[juan pedro].each do |name|
      FactoryBot.create(:user, login: name)
    end

    User.all.each { |user| UsersRepository.create!(user: user, repository: second_repository) }

    Technology.create_with(keyword_string: 'ruby,rails').find_or_create_by!(name: 'ruby')
    Technology.create_with(keyword_string: 'python,django').find_or_create_by!(name: 'python')
    Technology.create_with(keyword_string: '').find_or_create_by!(name: 'other')

    FactoryBot.create(:code_climate_repository_metric, repository: repository)
    FactoryBot.create(:code_climate_repository_metric, repository: second_repository)

    User.first(3).each { |user| CodeOwnerRepository.create!(user: user, repository: repository) }

    User.last(2).each { |user| CodeOwnerRepository.create!(user: user, repository: second_repository) }

    santiagovidal = User.find_by(login: 'santiagovidal')
    santib = User.find_by(login: 'santib')
    hernan = User.find_by(login: 'hdamico')
    horacio = User.find_by(login: 'horacio')
    hvilloria = User.find_by(login: 'hvilloria')
    sandro = User.find_by(login: 'sandro')

    # Review turnaround and Second review turnaround
    vita_pr = FactoryBot.create(:pull_request, owner: santiagovidal, repository: repository)
    vita_rr_santib = FactoryBot.create(:review_request, owner: santiagovidal, repository: repository, pull_request: vita_pr, reviewer: santib)
    FactoryBot.create(:review, owner: santib, repository: repository, pull_request: vita_pr, review_request: vita_rr_santib)

    vita_rr_hernan = FactoryBot.create(:review_request, owner: santiagovidal, repository: repository, pull_request: vita_pr, reviewer: hernan)
    FactoryBot.create(:review, owner: hernan, repository: repository, pull_request: vita_pr, review_request: vita_rr_hernan)

    # Merge Time
    hvilloria_pr = FactoryBot.create(
      :pull_request,
      owner: hvilloria,
      repository: repository,
      opened_at: 5.hours.ago,
      merged_at: Time.zone.now
    )
    Builders::MergeTime.call(hvilloria_pr)
    sandro_pr = FactoryBot.create(
      :pull_request,
      owner: sandro,
      repository: repository,
      opened_at: Time.zone.now - 14.hours,
      merged_at: Time.zone.now
    )
    Builders::MergeTime.call(sandro_pr)
    horacio_pr = FactoryBot.create(
      :pull_request,
      owner: horacio,
      repository: repository,
      opened_at: Time.zone.now - 27.hours,
      merged_at: Time.zone.now
    )
    Builders::MergeTime.call(horacio_pr)
  end

  MetricDefinition.create!(code: :defect_escape_rate, explanation: 'Is the ratio of defects filed by customer or end user, for a particular release to the total number of defects for that release.', name: 'Defect Escape Rate')
  MetricDefinition.create!(code: :review_turnaround, explanation: 'The time it takes for the PR to have feedback from two reviewers. Feedback includes the approval of the PR, but also a change suggestion or other comments.', name: 'Time to second review')
  MetricDefinition.create!(code: :merge_time, explanation: 'Time to merge measures the amount of time from pull request open until pull request merge.', name: 'Time to merge')
  MetricDefinition.create!(code: :pull_request_size, explanation: 'Measures the lines of code added by each PR. The smaller the PR, the easier it is to review, which speeds up the review process..', name: 'PR Size')
  MetricDefinition.create!(code: :development_cycle, explanation: 'It measures how much time the team spends working on a task.', name: 'Development Cycle')
  MetricDefinition.create!(code: :planned_to_done, explanation: 'The planned-to-done ratio measures what percentage of the tasks you set out for your team were completed satisfactorily.', name: 'Planned to Done Ratio')
end
