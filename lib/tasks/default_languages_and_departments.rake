# frozen_string_literal: true

namespace :one_time do
  desc 'it creates default departments and languages'
  task default_languages_and_departments: :environment do
    puts 'Creating departments and languages...'
    ActiveRecord::Base.transaction do
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
    end
    puts 'Done!'
  end
end
