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
        { name: 'ruby',
          keyword_string: 'ruby,rails,ruby on rails' },
        { name: 'python',
          keyword_string: 'python,django' },
        { name: 'ios',
          keyword_string: 'ios,swift' },
        { name: 'android',
          keyword_string: 'android' },
        { name: 'react',
          keyword_string: 'react,reactjs' },
        { name: 'react native',
          keyword_string: 'react native,react-native' },
        { name: 'machine learning',
          keyword_string: 'machine learning,data science,artificial intelligence' },
        { name: 'other',
          keyword_string: '' }
      ]
    end
  end
end
