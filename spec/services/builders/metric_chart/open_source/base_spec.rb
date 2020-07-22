require 'rails_helper'

RSpec.describe Builders::MetricChart::OpenSource::Base do
  subject { Builders::MetricChart::OpenSource::LanguageVisits }

  describe 'languages included' do
    it 'does not include the unassigned language' do
      expect(subject.call.datasets).not_to include(a_hash_including(name: 'Unassigned'))
    end
  end
end
