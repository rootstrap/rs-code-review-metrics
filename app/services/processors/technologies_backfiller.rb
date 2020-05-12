module Processors
  class TechnologiesBackfiller < BaseService
    def call
      init_attributes.each do |tech_attributes|
        technology = Technology.find_or_initialize_by(name: tech_attributes[:name])
        technology.keyword_string = tech_attributes[:keyword_string]
        technology.save!
      end
    end

    private

    def init_attributes
      [
        { name: 'ruby', keyword_string: 'ruby,rails' },
        { name: 'python', keyword_string: 'python,django' },
        { name: 'ios', keyword_string: 'ios' },
        { name: 'android', keyword_string: 'android' },
        { name: 'react', keyword_string: 'react' },
        { name: 'machine learning', keyword_string: 'machine learning' },
        { name: 'other', keyword_string: '' }
      ]
    end
  end
end
